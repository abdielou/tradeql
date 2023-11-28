enum ASTNodeType
{
    TYPE_PATTERN_NODE,
};

class ASTNode
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
