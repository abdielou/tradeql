#include <Arrays\ArrayObj.mqh>
#include "../Common.mqh"
#include "../bar/Bar.mqh"
#include "../bar/Trend.mqh"
#include "../bar/Match.mqh"
#include "../parse/ast/ASTNode.mqh"
#include "../parse/ast/PatternNode.mqh"
#include "../parse/ast/AltExprNode.mqh"
#include "../parse/ast/GroupNode.mqh"
#include "../parse/ast/SequenceExprNode.mqh"
#include "ImbalanceMatcher.mqh"
#include "PinbarMatcher.mqh"

class Matcher
{
private:
    CArrayObj *bars;
    Trend trend;

    ImbalanceMatcher *imbMatcher;
    PinbarMatcher *pinMatcher;

    bool Imbalance(int index)
    {
        if (imbMatcher != NULL)
        {
            return imbMatcher.IsMatch(index);
        }
        Print("WARNING: Imbalance Matcher not implemented");
        return false;
    }

    bool Pinbar(int index, bool &isRejectedHigh)
    {
        if (pinMatcher != NULL)
        {
            return pinMatcher.IsMatch(index, isRejectedHigh);
        }
        Print("WARNING: Pinbar Matcher not implemented");
        return false;
    }

    bool IsBullish(int index)
    {
        Bar *bar = (Bar *)bars.At(index);
        if (bar == NULL)
            return false;
        return bar.close > bar.open;
    }

    double CenterOfMass(Match *match)
    {
        double centerOfMass = 0;
        for (int i = match.GetStart(); i <= match.GetEnd(); ++i)
        {
            Bar *bar = (Bar *)bars.At(i);
            bool isBullish = IsBullish(i);
            double mass = isBullish ? bar.close - bar.open : bar.open - bar.close;
            centerOfMass += mass / 2 + (isBullish ? bar.open : bar.close);
        }
        centerOfMass /= match.GetEnd() - match.GetStart() + 1;
        return centerOfMass;
    }

    void AddMatchesToMainList(CArrayObj *mainList, CArrayObj *tempList)
    {
        for (int i = 0; i < tempList.Total(); ++i)
        {
            Match *tempMatch = (Match *)tempList.At(i);
            Match *newMatch = new Match(tempMatch.GetStart(), tempMatch.GetEnd(), tempMatch.IsGroupMatch());
            mainList.Add(newMatch);
        }
    }

    void MatchPatternNode(PatternNode *node, CArrayObj *matches, int startIndex, CArrayObj *globalTemporaryMatches)
    {
        Match *match = new Match(startIndex);
        for (int i = startIndex; i >= 0; i--)
        {
            // Handle direction
            bool isDirectionMatch = false;
            if (node.GetDirection() == DIRECTION_FORWARD)
            {
                isDirectionMatch = trend == TREND_BULLISH ? IsBullish(i) : !IsBullish(i);
            }
            else if (node.GetDirection() == DIRECTION_REVERSE)
            {
                isDirectionMatch = trend == TREND_BULLISH ? !IsBullish(i) : IsBullish(i);
            }
            else
            {
                isDirectionMatch = true;
            }

            // Handle pattern
            bool isPatternMatch = false;
            bool isRejectedHigh = false;
            if (node.GetPattern() == PATTERN_IMBALANCE)
            {
                isPatternMatch = Imbalance(i);
            }
            else if (node.GetPattern() == PATTERN_PINBAR)
            {
                isPatternMatch = Pinbar(i, isRejectedHigh);
                if (node.GetDirection() != DIRECTION_UNKNOWN)
                {
                    // Override direction. Special case for pinbar
                    bool isRejectedForward = trend == TREND_BULLISH ? !isRejectedHigh : isRejectedHigh;
                    isDirectionMatch = (node.GetDirection() == DIRECTION_FORWARD && isRejectedForward) || (node.GetDirection() == DIRECTION_REVERSE && !isRejectedForward);
                }
            }
            else if (node.GetPattern() == PATTERN_BAR)
            {
                isPatternMatch = !Imbalance(i) && !Pinbar(i, isRejectedHigh);
            }
            else
            {
                isPatternMatch = false;
            }

            // Handle quantifier
            if (node.GetQuantifier() == QUANTIFIER_ZERO_OR_MORE)
            {
                if (isPatternMatch && isDirectionMatch) // Match found, but continue to grab as many bars as possible
                {
                    match.SetEnd(i);
                    continue;
                }
                else if (match.GetEnd() != -1) // Not a match, but we have a previous match, therefore we are done matching, return
                {
                    matches.Add(match);
                    return;
                }
                else // Not a match, and we don't have a previous match. Since this is a zero or more quantifier, we can add this as a match and return
                {
                    matches.Add(match); // match.end==-1, therefore a zero match
                    return;
                }
            }
            else if (node.GetQuantifier() == QUANTIFIER_ONE_OR_MORE)
            {
                if (isPatternMatch && isDirectionMatch) // Match found, but continue to grab as many bars as possible
                {
                    match.SetEnd(i);
                    continue;
                }
                else if (match.GetEnd() != -1) // Not a match, but we have a previous match, therefore we are done matching, return
                {
                    matches.Add(match);
                    return;
                }
                else // Not a match, and we don't have a previous match. Since this is a one or more quantifier, we cannot mark this as a match
                {
                    delete match;
                    return;
                }
            }
            else
            {
                if (isPatternMatch && isDirectionMatch) // Match found and return since this is a one match quantifier
                {
                    match.SetEnd(i);
                    matches.Add(match);
                    return;
                }
                else // Not a match, return as no match found
                {
                    delete match;
                    return;
                }
            }
        }
        // Check if we have matches
        if (match.GetEnd() != -1)
        {
            match.SetEnd(0); // We ran out of bars
            matches.Add(match);
        }
        else
        {
            delete match;
        }
        return;
    }

    void MatchAltExprNode(AltExprNode *node, CArrayObj *matches, int startIndex, CArrayObj *globalTemporaryMatches)
    {
        for (int i = 0; i < node.GetExpressions().Total(); ++i)
        {
            ASTNode *alternative = node.GetExpressions().At(i);
            CArrayObj *tempMatches = new CArrayObj();
            _IsMatch(alternative, tempMatches, startIndex, globalTemporaryMatches);

            if (tempMatches.Total() > 0)
            {
                AddMatchesToMainList(matches, tempMatches);
                delete tempMatches;
                break; // Match found in one of the alternatives, no need to check further
            }
            delete tempMatches;
        }
        Match *match = (Match *)matches.At(matches.Total() - 1);
    }

    void MatchGroupNode(GroupNode *node, CArrayObj *matches, int startIndex, CArrayObj *globalTemporaryMatches, bool capturing = true)
    {
        ASTNode *innerExpr = node.GetInnerExpression();
        Quantifier quantifier = node.GetQuantifier();
        CArrayObj *tempMatches = new CArrayObj(); // Hold group matches to later join into a single match

        if (quantifier == QUANTIFIER_ZERO_OR_MORE || quantifier == QUANTIFIER_ONE_OR_MORE)
        {
            int currentIndex = startIndex;
            while (currentIndex < bars.Total())
            {
                CArrayObj *innerMatches = new CArrayObj();
                _IsMatch(innerExpr, innerMatches, currentIndex, globalTemporaryMatches);

                if (innerMatches.Total() > 0)
                {
                    // Add all matches from innerMatches to tempMatches
                    AddMatchesToMainList(tempMatches, innerMatches);
                    Match *lastMatch = (Match *)innerMatches.At(innerMatches.Total() - 1);
                    currentIndex = lastMatch.GetEnd() - 1;
                }
                else
                {
                    delete innerMatches;
                    break;
                }

                delete innerMatches;
            }
        }
        else
        {
            _IsMatch(innerExpr, tempMatches, startIndex, globalTemporaryMatches);
        }

        if (tempMatches.Total() > 0) // Join matches into a single match
        {
            Match *firstMatch = (Match *)tempMatches.At(0);
            Match *lastMatch = (Match *)tempMatches.At(tempMatches.Total() - 1);
            Match *groupMatch = new Match(firstMatch.GetStart(), lastMatch.GetEnd());
            groupMatch.SetGroupMatch(capturing);
            matches.Add(groupMatch);

            // Keep any group match in tempMatches
            for (int i = 0; i < tempMatches.Total(); ++i)
            {
                Match *tempMatch = (Match *)tempMatches.At(i);
                if (tempMatch.IsGroupMatch())
                {
                    Match *newMatch = new Match(tempMatch.GetStart(), tempMatch.GetEnd(), tempMatch.IsGroupMatch());
                    matches.Add(newMatch);
                }
            }
        }
        else if (quantifier == QUANTIFIER_ZERO_OR_MORE) // Add a zero match
        {
            Match *zeroMatch = new Match(startIndex, startIndex - 1);
            matches.Add(zeroMatch);
        }

        // Validate Position against globalTemporaryMatches
        Position position = node.GetPosition();
        if (position == POSITION_BEYOND || position == POSITION_BEHIND)
        {
            // Get current group match
            Match *currentGroupMatch = (Match *)matches.At(matches.Total() - 1);

            // Find previous group match in globalTemporaryMatches
            Match *previousGroupMatch = NULL;
            for (int i = globalTemporaryMatches.Total() - 1; i >= 0; --i)
            {
                Match *tempMatch = (Match *)globalTemporaryMatches.At(i);
                if (tempMatch.IsGroupMatch())
                {
                    previousGroupMatch = tempMatch;
                    break;
                }
            }

            // If previous
            if (previousGroupMatch != NULL && currentGroupMatch != NULL)
            {
                // Calculate average mass
                double currentGroupMatchCenterOfMass = CenterOfMass(currentGroupMatch);
                double previousGroupMatchCenterOfMass = CenterOfMass(previousGroupMatch);
                bool isBeyond = trend == TREND_BULLISH ? currentGroupMatchCenterOfMass > previousGroupMatchCenterOfMass : currentGroupMatchCenterOfMass < previousGroupMatchCenterOfMass;

                if ((position == POSITION_BEYOND && !isBeyond) || (position == POSITION_BEHIND && isBeyond))
                {
                    // Incorrect position. Remove and delete current group match
                    matches.Delete(matches.Total() - 1);
                    delete currentGroupMatch;
                }
            }
        }

        // Cleanup
        delete tempMatches;
    }

    void MatchSequenceExprNode(SequenceExprNode *node, CArrayObj *matches, int startIndex, CArrayObj *globalTemporaryMatches)
    {
        int currentIndex = startIndex;
        bool sequenceFullyMatched = true;

        CArrayObj *tempMatches = new CArrayObj(); // Hold sequence matches to later join into a single match

        for (int i = 0; i < node.GetExpressions().Total(); ++i) // Iterate through all expressions in the sequence
        {
            ASTNode *expr = node.GetExpressions().At(i);
            CArrayObj *innerMatches = new CArrayObj();

            _IsMatch(expr, innerMatches, currentIndex, tempMatches);

            if (innerMatches.Total() > 0) // Expression matched, continue to next expression
            {
                AddMatchesToMainList(tempMatches, innerMatches);
                Match *lastMatch = (Match *)innerMatches.At(innerMatches.Total() - 1);
                currentIndex = lastMatch.GetEnd() - 1;
            }
            else // No match, therefore sequence not matched
            {
                sequenceFullyMatched = false;
                delete innerMatches;
                break;
            }

            delete innerMatches;
        }

        if (sequenceFullyMatched) // Join matches into a single match
        {
            Match *firstMatch = (Match *)tempMatches.At(0);
            Match *lastMatch = (Match *)tempMatches.At(tempMatches.Total() - 1);
            Match *sequenceMatch = new Match(firstMatch.GetStart(), lastMatch.GetEnd());
            matches.Add(sequenceMatch);

            // Keep any group match in tempMatches
            for (int i = 0; i < tempMatches.Total(); ++i)
            {
                Match *tempMatch = (Match *)tempMatches.At(i);
                if (tempMatch.IsGroupMatch())
                {
                    Match *newMatch = new Match(tempMatch.GetStart(), tempMatch.GetEnd(), tempMatch.IsGroupMatch());
                    matches.Add(newMatch);
                }
            }
        }
        delete tempMatches;
    }

    void _IsMatch(ASTNode *node, CArrayObj *matches, int startIndex, CArrayObj *globalTemporaryMatches)
    {
        switch (node.GetNodeType())
        {
        case TYPE_SEQUENCE_EXPR_NODE:
            MatchSequenceExprNode(node, matches, startIndex, globalTemporaryMatches);
            break;
        case TYPE_GROUP_NODE:
            MatchGroupNode(node, matches, startIndex, globalTemporaryMatches);
            break;
        case TYPE_NON_CAPTURING_GROUP_NODE:
            MatchGroupNode(node, matches, startIndex, globalTemporaryMatches, false);
            break;
        case TYPE_ALT_EXPR_NODE:
            MatchAltExprNode(node, matches, startIndex, globalTemporaryMatches);
            break;
        case TYPE_PATTERN_NODE:
            MatchPatternNode(node, matches, startIndex, globalTemporaryMatches);
            break;
        default:
            Print("WARNING: Unknown node type");
            break;
        }
    }

public:
    Matcher(CArrayObj *pbars, Trend ptrend, PatternMatcher *imbalanceMatcher = NULL, PatternMatcher *pinbarMatcher = NULL) : bars(pbars), trend(ptrend), imbMatcher(imbalanceMatcher), pinMatcher(pinbarMatcher)
    {
        if (imbMatcher == NULL)
            imbMatcher = new ImbalanceMatcher();
        imbMatcher.SetBars(*bars);

        if (pinMatcher == NULL)
            pinMatcher = new PinbarMatcher();
        pinMatcher.SetBars(*bars);
    }

    ~Matcher()
    {
        if (imbMatcher != NULL)
            delete imbMatcher;
        if (pinMatcher != NULL)
            delete pinMatcher;
    }

    void IsMatch(ASTNode *node, CArrayObj *matches)
    {
        _IsMatch(node, matches, bars.Total() - 1, NULL);
    }
};
