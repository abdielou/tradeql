#include "../Include/TradeQL.mqh"

bool MyCustomImbalanceFunction(TradeQL &tradeQL, int index)
{
    TqlBar *bar = tradeQL.GetBar(index);
    Print("MyCustomImbalanceFunction: " + DoubleToString(bar.open));
    return true;
}

void OnStart()
{
    // Init
    TqlTrend bullish = TqlTrend::bullish;
    CArrayObj *bars = new CArrayObj();
    PopulateBars(*bars);
    TradeQL *tradeQL = new TradeQL(*bars, bullish);

    // Use
    tradeQL.SetImbalanceFunc(MyCustomImbalanceFunction);
    TqlMatch match;
    tradeQL.Match("I+f", match);

    // Cleanup
    delete tradeQL;
    delete bars;
}

void PopulateBars(CArrayObj &bars)
{
    for (int i = 0; i < 100; i++)
    {
        TqlBar *bar = new TqlBar();
        bar.open = 1.0;
        bar.close = 1.0;
        bar.high = 1.0;
        bar.low = 1.0;
        bars.Add(bar);
    }
}