#include <Arrays\ArrayObj.mqh>
#include "../Common.mqh"
#include "../bar/Bar.mqh"
#include "../bar/Trend.mqh"
#include "../bar/Match.mqh"
#include "../parse/ast/ASTNode.mqh"
#include "../parse/ast/PatternNode.mqh"
#include "../parse/ast/AltExprNode.mqh"
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
        return;
    }

    void MatchAltExprNode(AltExprNode *node, CArrayObj *matches, int startIndex)
    {
        for (int i = 0; i < node.GetExpressions().Total(); ++i)
        {
            PatternNode *alternative = (PatternNode *)node.GetExpressions().At(i);
            CArrayObj *tempMatches = new CArrayObj();
            MatchPatternNode(alternative, tempMatches, startIndex);

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

    void AddMatchesToMainList(CArrayObj *mainList, CArrayObj *tempList)
    {
        for (int i = 0; i < tempList.Total(); ++i)
        {
            Match *tempMatch = (Match *)tempList.At(i);
            Match *newMatch = new Match(tempMatch.GetStart(), tempMatch.GetEnd());
            mainList.Add(newMatch);
        }
    }

    void MatchGroupNode(ASTNode *node, CArrayObj *matches, int startIndex)
    {
        Print("WARNING: GroupNode not implemented");
    }

    void MatchSequenceExprNode(ASTNode *node, CArrayObj *matches, int startIndex)
    {
        Print("WARNING: SequenceExprNode not implemented");
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

    void IsMatch(ASTNode *node, CArrayObj *matches)
    {
        switch (node.GetNodeType())
        {
        case TYPE_SEQUENCE_EXPR_NODE:
            MatchSequenceExprNode(node, matches, 0);
            break;
        case TYPE_GROUP_NODE:
            MatchGroupNode(node, matches, 0);
            break;
        case TYPE_ALT_EXPR_NODE:
            MatchAltExprNode(node, matches, 0);
            break;
        case TYPE_PATTERN_NODE:
            MatchPatternNode(node, matches, 0);
            break;
        default:
            Print("WARNING: Unknown node type");
            break;
        }
    }
};
