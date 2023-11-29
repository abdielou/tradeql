#include "ASTNode.mqh"

class GroupNode : public ASTNode
{
private:
    ASTNode *innerExpression;
    string quantifier;

public:
    GroupNode(ASTNode *innerExpr, string quant = "") : ASTNode(TYPE_GROUP_NODE), innerExpression(innerExpr), quantifier(quant) {}

    ~GroupNode()
    {
        delete innerExpression;
    }

    ASTNode *GetInnerExpression() const
    {
        return innerExpression;
    }

    string GetQuantifier() const
    {
        return quantifier;
    }
};
