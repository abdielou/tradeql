#include <Arrays\ArrayObj.mqh>
#include "../Common.mqh"
#include "../bar/Bar.mqh"
#include "../bar/Trend.mqh"
#include "../bar/Match.mqh"
#include "../parse/ast/ASTNode.mqh"
#include "../parse/ast/PatternNode.mqh"
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

    void MatchPatternNode(PatternNode *node, CArrayObj *matches, int startIndex)
    {
        // TODO
    }

    void MatchAltExprNode(ASTNode *node, CArrayObj *matches, int startIndex)
    {
        // TODO
    }

    void MatchGroupNode(ASTNode *node, CArrayObj *matches, int startIndex)
    {
        // TODO
    }

    void MatchSequenceExprNode(ASTNode *node, CArrayObj *matches, int startIndex)
    {
        // TODO
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

    void Match(ASTNode *node, CArrayObj *matches)
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
        }
    }
};
