enum ASTNodeType
{
    TYPE_PATTERN_NODE,
    TYPE_ALT_EXPR_NODE,
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
