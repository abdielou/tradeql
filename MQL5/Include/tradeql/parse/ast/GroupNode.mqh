#include "ASTNode.mqh"
#include "../../pattern/Quantifier.mqh"
#include "../../pattern/Position.mqh"

class GroupNode : public ASTNode
{
private:
    ASTNode *innerExpression;
    Quantifier quantifier;
    Position position;

public:
    GroupNode(ASTNode *innerExpr, Quantifier quant = QUANTIFIER_UNKNOWN, Position pos = POSITION_UNKNOWN) : ASTNode(TYPE_GROUP_NODE), innerExpression(innerExpr), quantifier(quant), position(pos) {}

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

    Position GetPosition() const
    {
        return position;
    }
};
