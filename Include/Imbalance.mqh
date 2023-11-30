#include "TradeQL.mqh"

bool Imbalance(TradeQL &tradeQL, int index)
{
    // Validate there's enough data to calculate
    if (index < 1 || index > tradeQL.GetBarCount() - 2)
    {
        Print("ERROR: Not enough data to calculate Imbalance at index ", index);
        return false;
    }

    // Get bars
    Bar *target = tradeQL.GetBar(index);
    Bar *prev = tradeQL.GetBar(index + 1);
    Bar *next = tradeQL.GetBar(index - 1);

    // Calculate
    bool isBullish = target.close > target.open;
    bool hasImbalance = isBullish ? prev.high < next.low : prev.low > next.high;
    return hasImbalance;
}
