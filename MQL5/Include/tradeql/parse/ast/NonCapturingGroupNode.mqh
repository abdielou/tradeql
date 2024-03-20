#include "GroupNode.mqh"

class NonCapturingGroupNode : public GroupNode
{
public:
    NonCapturingGroupNode(ASTNode *innerExpr, Quantifier quant = QUANTIFIER_UNKNOWN, Position pos = POSITION_UNKNOWN)
        : GroupNode(innerExpr, quant, pos)
    {
        SetNodeType(TYPE_NON_CAPTURING_GROUP_NODE);
    }
};
