#include <Arrays\ArrayObj.mqh>
#include "ASTNode.mqh"

class SequenceExprNode : public ASTNode
{
private:
    CArrayObj *expressions;

public:
    SequenceExprNode() : ASTNode(TYPE_SEQUENCE_EXPR_NODE)
    {
        expressions = new CArrayObj();
    }

    void AddExpression(ASTNode *expr)
    {
        expressions.Add(expr);
    }

    CArrayObj *GetExpressions() const
    {
        return expressions;
    }

    virtual ~SequenceExprNode()
    {
        for (int i = 0; i < expressions.Total(); i++)
        {
            delete expressions.At(i);
        }
        delete expressions;
    }
};
