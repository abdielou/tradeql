#include <Arrays\ArrayObj.mqh>
#include "../bar/Bar.mqh"

class PatternMatcher
{
private:
    CArrayObj *bars;

public:
    PatternMatcher() {}
    virtual ~PatternMatcher() {}
    void SetBars(CArrayObj &pbars) { bars = &pbars; }
    int GetBarCount()
    {
        if (bars == NULL)
        {
            return 0;
        }
        return bars.Total();
    }
    Bar *GetBar(int index)
    {
        if (bars == NULL)
        {
            return NULL;
        }
        return (Bar *)bars.At(index);
    }
    virtual bool IsMatch(const int index) = 0;
};
