#include "../Include/match/ImbalanceMatcher.mqh"

void OnStart()
{
    // Init
    CArrayObj *bars = new CArrayObj();
    PopulateBars(*bars);

    // Test Imbalance
    ImbalanceMatcher matcher(bars);
    bool hasImbalance = matcher.IsMatch(1); // 1 has imbalance
    if (!hasImbalance)
        Print("[FAIL] Imbalance test failed");
    else
        Print("[PASS] Imbalance test passed");

    // Cleanup
    delete bars;
}

void PopulateBars(CArrayObj &bars)
{
    Bar *bar2 = new Bar();
    bar2.high = 7;
    bar2.close = 6;
    bar2.open = 4;
    bar2.low = 3.5;
    bars.Add(bar2);

    Bar *bar1 = new Bar(); // Has imbalance
    bar1.high = 5;
    bar1.close = 4;
    bar1.open = 2;
    bar1.low = 1.5;
    bars.Add(bar1);

    Bar *bar0 = new Bar();
    bar0.high = 3;
    bar0.close = 2;
    bar0.open = 1;
    bar0.low = 0;
    bars.Add(bar0);
}