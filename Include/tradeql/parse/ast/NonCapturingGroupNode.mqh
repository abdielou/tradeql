#include "ASTNode.mqh"
#include "../../pattern/Quantifier.mqh"

class NonCapturingGroupNode : public ASTNode
{
private:
    ASTNode *innerExpression;
    Quantifier quantifier;

public:
    NonCapturingGroupNode(ASTNode *innerExpr, Quantifier quant = QUANTIFIER_UNKNOWN) : ASTNode(TYPE_NON_CAPTURING_GROUP_NODE), innerExpression(innerExpr), quantifier(quant) {}

    ~NonCapturingGroupNode()
    {
        delete innerExpression;
    }

    ASTNode *GetInnerExpression() const
    {
        return innerExpression;
    }

    Quantifier GetQuantifier() const
    {
        return quantifier;
    }
};
