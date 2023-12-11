#include "ASTNode.mqh"
#include "../../pattern/Quantifier.mqh"

class GroupNode : public ASTNode
{
private:
    ASTNode *innerExpression;
    Quantifier quantifier;

public:
    GroupNode(ASTNode *innerExpr, Quantifier quant = QUANTIFIER_UNKNOWN) : ASTNode(TYPE_GROUP_NODE), innerExpression(innerExpr), quantifier(quant) {}

    ~GroupNode()
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
