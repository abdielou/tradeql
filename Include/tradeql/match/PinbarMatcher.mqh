#include "PatternMatcher.mqh"

class PinbarMatcher : public PatternMatcher
{
public:
    PinbarMatcher() : PatternMatcher() {}
    bool IsMatch(const int index)
    {
        return false;
    }
};
