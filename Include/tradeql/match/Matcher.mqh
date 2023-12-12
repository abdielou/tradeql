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
#include "PatternMatcher.mqh"
#include "ImbalanceMatcher.mqh"

class Matcher
{
private:
    CArrayObj *bars;
    Trend trend;

    PatternMatcher *imbMatcher;
    PatternMatcher *pinMatcher;

    bool Imbalance(int index)
    {
        if (imbMatcher != NULL)
        {
            return imbMatcher.IsMatch(index);
        }
        Print("WARNING: Imbalance Matcher not implemented");
        return false;
    }

    bool Pinbar(int index)
    {
        if (pinMatcher != NULL)
        {
            return pinMatcher.IsMatch(index);
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

    void AddMatchesToMainList(CArrayObj *mainList, CArrayObj *tempList)
    {
        for (int i = 0; i < tempList.Total(); ++i)
        {
            Match *tempMatch = (Match *)tempList.At(i);
            Match *newMatch = new Match(tempMatch.GetStart(), tempMatch.GetEnd(), tempMatch.IsGroupMatch());
            mainList.Add(newMatch);
        }
    }

    void MatchPatternNode(PatternNode *node, CArrayObj *matches, int startIndex)
    {
        Match *match = new Match(startIndex);
        for (int i = startIndex; i < bars.Total(); ++i)
        {
            // Handle pattern
            bool isPatternMatch = false;
            if (node.GetPattern() == PATTERN_IMBALANCE)
            {
                isPatternMatch = Imbalance(i);
            }
            else if (node.GetPattern() == PATTERN_PINBAR)
            {
                isPatternMatch = Pinbar(i);
            }
            else if (node.GetPattern() == PATTERN_BAR)
            {
                isPatternMatch = !Imbalance(i) && !Pinbar(i);
            }
            else
            {
                isPatternMatch = false;
            }

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
            match.SetEnd(bars.Total() - 1); // We ran out of bars
            matches.Add(match);
        }
        else
        {
            delete match;
        }
        return;
    }

    void MatchAltExprNode(AltExprNode *node, CArrayObj *matches, int startIndex)
    {
        for (int i = 0; i < node.GetExpressions().Total(); ++i)
        {
            ASTNode *alternative = node.GetExpressions().At(i);
            CArrayObj *tempMatches = new CArrayObj();
            IsMatch(alternative, tempMatches, startIndex);

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

    void MatchGroupNode(GroupNode *node, CArrayObj *matches, int startIndex)
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
                IsMatch(innerExpr, innerMatches, currentIndex);

                if (innerMatches.Total() > 0)
                {
                    // Add all matches from innerMatches to tempMatches
                    AddMatchesToMainList(tempMatches, innerMatches);
                    Match *lastMatch = (Match *)innerMatches.At(innerMatches.Total() - 1);
                    currentIndex = lastMatch.GetEnd() + 1;
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
            IsMatch(innerExpr, tempMatches, startIndex);
        }

        if (tempMatches.Total() > 0) // Join matches into a single match
        {
            Match *firstMatch = (Match *)tempMatches.At(0);
            Match *lastMatch = (Match *)tempMatches.At(tempMatches.Total() - 1);
            Match *groupMatch = new Match(firstMatch.GetStart(), lastMatch.GetEnd());
            groupMatch.SetGroupMatch(true);
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

        // Cleanup
        delete tempMatches;
    }

    void MatchSequenceExprNode(SequenceExprNode *node, CArrayObj *matches, int startIndex)
    {
        int currentIndex = startIndex;
        bool sequenceFullyMatched = true;

        CArrayObj *tempMatches = new CArrayObj(); // Hold sequence matches to later join into a single match

        for (int i = 0; i < node.GetExpressions().Total(); ++i) // Iterate through all expressions in the sequence
        {
            ASTNode *expr = node.GetExpressions().At(i);
            CArrayObj *innerMatches = new CArrayObj();

            IsMatch(expr, innerMatches, currentIndex);

            if (innerMatches.Total() > 0) // Expression matched, continue to next expression
            {
                AddMatchesToMainList(tempMatches, innerMatches);
                Match *lastMatch = (Match *)innerMatches.At(innerMatches.Total() - 1);
                currentIndex = lastMatch.GetEnd() + 1;
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

public:
    Matcher(CArrayObj *pbars, Trend ptrend, PatternMatcher *imbalanceMatcher = NULL, PatternMatcher *pinbarMatcher = NULL) : bars(pbars), trend(ptrend), imbMatcher(imbalanceMatcher), pinMatcher(pinbarMatcher)
    {
        if (imbMatcher == NULL)
            imbMatcher = new ImbalanceMatcher();
        imbMatcher.SetBars(*bars);

        if (pinMatcher == NULL)
            return; // Not provided
        pinMatcher.SetBars(*bars);
    }

    ~Matcher()
    {
        if (imbMatcher != NULL)
            delete imbMatcher;
        if (pinMatcher != NULL)
            delete pinMatcher;
    }

    void IsMatch(ASTNode *node, CArrayObj *matches, int startIndex = 0)
    {
        switch (node.GetNodeType())
        {
        case TYPE_SEQUENCE_EXPR_NODE:
            MatchSequenceExprNode(node, matches, startIndex);
            break;
        case TYPE_GROUP_NODE:
            MatchGroupNode(node, matches, startIndex);
            break;
        case TYPE_ALT_EXPR_NODE:
            MatchAltExprNode(node, matches, startIndex);
            break;
        case TYPE_PATTERN_NODE:
            MatchPatternNode(node, matches, startIndex);
            break;
        default:
            Print("WARNING: Unknown node type");
            break;
        }
    }
};
