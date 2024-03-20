#include <Arrays\ArrayObj.mqh>
#include "ASTNode.mqh"

class AltExprNode : public ASTNode
{
private:
    CArrayObj *expressions;

public:
    AltExprNode() : ASTNode(TYPE_ALT_EXPR_NODE)
    {
        expressions = new CArrayObj();
    }

    ~AltExprNode()
    {
        for (int i = 0; i < expressions.Total(); i++)
        {
            delete expressions.At(i);
        }
        delete expressions;
    }

    void AddExpression(ASTNode *expr)
    {
        expressions.Add(expr);
    }

    CArrayObj *GetExpressions() const
    {
        return expressions;
    }
};
