#include "PatternMatcher.mqh"

class ImbalanceMatcher : public PatternMatcher
{
public:
    ImbalanceMatcher(CArrayObj &pbars) : PatternMatcher(pbars) {}
    bool IsMatch(const int index)
    {
        // Validate there's enough data to calculate
        if (index < 1 || index > GetBarCount() - 2)
        {
            Print("ERROR: Not enough data to calculate Imbalance at index ", index);
            return false;
        }

        // Get bars
        Bar *target = GetBar(index);
        Bar *prev = GetBar(index + 1);
        Bar *next = GetBar(index - 1);

        // Calculate
        bool isBullish = target.close > target.open;
        bool hasImbalance = isBullish ? prev.high < next.low : prev.low > next.high;
        return hasImbalance;
    }
};
