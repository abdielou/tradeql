#include <Arrays\ArrayObj.mqh>
#include "../bar/Bar.mqh"

class PatternMatcher
{
private:
    CArrayObj *bars;

public:
    PatternMatcher(CArrayObj &pbars) : bars(&pbars) {}
    virtual ~PatternMatcher() {}
    Bar *GetBar(int index) { return bars.At(index); }
    int GetBarCount() { return bars.Total(); }
    virtual bool IsMatch(const int index) = 0;
};
