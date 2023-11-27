#include "../Include/TradeQL.mqh"
#include "../Include/Imbalance.mqh"

void OnStart()
{
    TestImbalance();
}

void TestImbalance()
{
    // Init
    TqlTrend bullish = TqlTrend::bullish;
    CArrayObj *bars = new CArrayObj();
    PopulateBars(*bars);
    TradeQL *tradeQL = new TradeQL(*bars, bullish);

    // Test Imbalance
    bool hasImbalance = Imbalance(tradeQL, 1); // 1 has imbalance
    if (!hasImbalance)
        Print("[FAIL] Imbalance test failed");
    else
        Print("[PASS] Imbalance test passed");

    // Cleanup
    delete tradeQL;
    delete bars;
}

void PopulateBars(CArrayObj &bars)
{
    TqlBar *bar2 = new TqlBar();
    bar2.high = 7;
    bar2.close = 6;
    bar2.open = 4;
    bar2.low = 3.5;
    bars.Add(bar2);

    TqlBar *bar1 = new TqlBar(); // Has imbalance
    bar1.high = 5;
    bar1.close = 4;
    bar1.open = 2;
    bar1.low = 1.5;
    bars.Add(bar1);

    TqlBar *bar0 = new TqlBar();
    bar0.high = 3;
    bar0.close = 2;
    bar0.open = 1;
    bar0.low = 0;
    bars.Add(bar0);
}