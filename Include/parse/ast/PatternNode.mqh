#include "ASTNode.mqh"
#include "../../pattern/Pattern.mqh"
#include "../../pattern/Direction.mqh"
#include "../../pattern/Quantifier.mqh"

class PatternNode : public ASTNode
{
private:
    Pattern p;
    Direction d;
    Quantifier q;

public:
    PatternNode(string pattern) : ASTNode(TYPE_PATTERN_NODE), p(StringToPattern(pattern)), d(DIRECTION_UNKNOWN), q(QUANTIFIER_UNKNOWN) {}

    ~PatternNode() {}

    void SetDirection(string dir)
    {
        d = StringToDirection(dir);
    }
    void SetQuantifier(string quant)
    {
        q = StringToQuantifier(quant);
    }
    Pattern GetPattern() const
    {
        return p;
    }
    Direction GetDirection() const
    {
        return d;
    }
    Quantifier GetQuantifier() const
    {
        return q;
    }
};
