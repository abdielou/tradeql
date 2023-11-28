#include "ASTNode.mqh"

class PatternNode : public ASTNode
{
private:
    string p;
    string d;
    string q;

public:
    PatternNode(string pattern) : ASTNode(TYPE_PATTERN_NODE), p(pattern), d(""), q("") {}

    void SetDirection(string dir)
    {
        d = dir;
    }
    void SetQuantifier(string quant)
    {
        q = quant;
    }
    string GetPattern() const
    {
        return p;
    }
    string GetDirection() const
    {
        return d;
    }
    string GetQuantifier() const
    {
        return q;
    }
};
