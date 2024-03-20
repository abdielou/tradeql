#include "parse/ast/PatternNode.mqh"
#include "parse/ast/GroupNode.mqh"

string NodeTypeToString(const ASTNodeType type)
{
    switch (type)
    {
    case TYPE_PATTERN_NODE:
        return "TYPE_PATTERN_NODE";
    case TYPE_ALT_EXPR_NODE:
        return "TYPE_ALT_EXPR_NODE";
    case TYPE_GROUP_NODE:
        return "TYPE_GROUP_NODE";
    case TYPE_SEQUENCE_EXPR_NODE:
        return "TYPE_SEQUENCE_EXPR_NODE";
    default:
        return "";
    }
}

string PatternToString(const Pattern pattern)
{
    switch (pattern)
    {
    case PATTERN_BAR:
        return "B";
    case PATTERN_IMBALANCE:
        return "I";
    case PATTERN_PINBAR:
        return "P";
    default:
        return "";
    }
}

string DirectionToString(const Direction direction)
{
    switch (direction)
    {
    case DIRECTION_FORWARD:
        return "f";
    case DIRECTION_REVERSE:
        return "r";
    default:
        return "";
    }
}

string QuantifierToString(const Quantifier quantifier)
{
    switch (quantifier)
    {
    case QUANTIFIER_ZERO_OR_MORE:
        return "*";
    case QUANTIFIER_ONE_OR_MORE:
        return "+";
    default:
        return "";
    }
}

string PositionToString(const Position position)
{
    switch (position)
    {
    case POSITION_BEYOND:
        return "^";
    case POSITION_BEHIND:
        return "_";
    default:
        return "";
    }
}

void PrintASTTree(ASTNode *node, string indent)
{
    switch (node.GetNodeType())
    {
    case TYPE_SEQUENCE_EXPR_NODE:
        Print(indent, "SequenceExprNode");
        break;
    case TYPE_GROUP_NODE:
        Print(indent, "GroupNode ", QuantifierToString(((GroupNode *)node).GetQuantifier()), PositionToString(((GroupNode *)node).GetPosition()));
        break;
    case TYPE_NON_CAPTURING_GROUP_NODE:
        Print(indent, "NonCapturingGroupNode");
        break;
    case TYPE_ALT_EXPR_NODE:
        Print(indent, "AltExprNode");
        break;
    case TYPE_PATTERN_NODE:
        Print(indent, "PatternNode ", PatternToString(((PatternNode *)node).GetPattern()), DirectionToString(((PatternNode *)node).GetDirection()), QuantifierToString(((PatternNode *)node).GetQuantifier()));
        break;
    default:
        Print(indent, "WARNING: Unknown node type");
        break;
    }

    switch (node.GetNodeType())
    {
    case TYPE_SEQUENCE_EXPR_NODE:
    {
        SequenceExprNode *sequenceExprNode = (SequenceExprNode *)node;
        for (int i = 0; i < sequenceExprNode.GetExpressions().Total(); ++i)
        {
            ASTNode *expr = sequenceExprNode.GetExpressions().At(i);
            PrintASTTree(expr, indent + "  ");
        }
        break;
    }
    case TYPE_GROUP_NODE:
    {
        GroupNode *groupNode = (GroupNode *)node;
        PrintASTTree(groupNode.GetInnerExpression(), indent + "  ");
        break;
    }
    case TYPE_NON_CAPTURING_GROUP_NODE:
    {
        NonCapturingGroupNode *nonCapturingGroupNode = (NonCapturingGroupNode *)node;
        PrintASTTree(nonCapturingGroupNode.GetInnerExpression(), indent + "  ");
        break;
    }
    case TYPE_ALT_EXPR_NODE:
    {
        AltExprNode *altExprNode = (AltExprNode *)node;
        for (int i = 0; i < altExprNode.GetExpressions().Total(); ++i)
        {
            ASTNode *expr = altExprNode.GetExpressions().At(i);
            PrintASTTree(expr, indent + "  ");
        }
        break;
    }
    case TYPE_PATTERN_NODE:
    default:
        break;
    }
}
