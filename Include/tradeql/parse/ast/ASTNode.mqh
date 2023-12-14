#include <Arrays\ArrayObj.mqh>

enum ASTNodeType
{
    TYPE_PATTERN_NODE,
    TYPE_ALT_EXPR_NODE,
    TYPE_GROUP_NODE,
    TYPE_NON_CAPTURING_GROUP_NODE,
    TYPE_SEQUENCE_EXPR_NODE
};

class ASTNode : public CObject
{
protected:
    ASTNodeType nodeType;

public:
    ASTNode(ASTNodeType type) : nodeType(type) {}
    virtual ~ASTNode() {}

    ASTNodeType GetNodeType() const
    {
        return nodeType;
    }
};
