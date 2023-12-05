#include "parse/ast/PatternNode.mqh"

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
        return "UNKNOWN";
    }
}

string PatternToString(const Pattern pattern)
{
    switch (pattern)
    {
    case PATTERN_BAR:
        return "PATTERN_BAR";
    case PATTERN_IMBALANCE:
        return "PATTERN_IMBALANCE";
    case PATTERN_PINBAR:
        return "PATTERN_PINBAR";
    default:
        return "UNKNOWN";
    }
}

string DirectionToString(const Direction direction)
{
    switch (direction)
    {
    case DIRECTION_FORWARD:
        return "DIRECTION_FORWARD";
    case DIRECTION_REVERSE:
        return "DIRECTION_REVERSE";
    default:
        return "UNKNOWN";
    }
}

string QuantifierToString(const Quantifier quantifier)
{
    switch (quantifier)
    {
    case QUANTIFIER_ZERO_OR_MORE:
        return "QUANTIFIER_ZERO_OR_MORE";
    case QUANTIFIER_ONE_OR_MORE:
        return "QUANTIFIER_ONE_OR_MORE";
    default:
        return "UNKNOWN";
    }
}