#include "TradeQL.mqh"

bool TqlImbalance(TradeQL &tradeQL, int index)
{
    // Validate there's enough data to calculate
    if (index < 1 || index > tradeQL.GetBarCount() - 2)
    {
        Print("ERROR: Not enough data to calculate TqlImbalance at index ", index);
        return false;
    }

    // Get bars
    TqlBar *target = tradeQL.GetBar(index);
    TqlBar *prev = tradeQL.GetBar(index + 1);
    TqlBar *next = tradeQL.GetBar(index - 1);

    // Calculate
    bool isBullish = target.close > target.open;
    bool hasImbalance = isBullish ? prev.high < next.low : prev.low > next.high;
    return hasImbalance;
}
