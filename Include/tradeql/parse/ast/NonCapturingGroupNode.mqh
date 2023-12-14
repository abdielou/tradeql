#include "GroupNode.mqh"

class NonCapturingGroupNode : public GroupNode
{
public:
    NonCapturingGroupNode(ASTNode *innerExpr, Quantifier quant = QUANTIFIER_UNKNOWN)
        : GroupNode(innerExpr, quant)
    {
        SetNodeType(TYPE_NON_CAPTURING_GROUP_NODE);
    }
};
