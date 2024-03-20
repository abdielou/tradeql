#include "../Include/tradeql/match/PinbarMatcher.mqh"

void TestIsPinbar()
{
    // Init
    CArrayObj *bars = new CArrayObj();
    PopulateBars(*bars);

    // Test Pinbar
    PinbarMatcher matcher;
    matcher.SetBars(*bars);
    bool isPinbar = matcher.IsMatch(2); // 2 (bar1) is pinbar
    if (!isPinbar)
        Print("[FAIL] Pinbar test failed");
    else
        Print("[PASS] Pinbar test passed");

    // Cleanup
    for (int i = 0; i < bars.Total(); ++i)
    {
        Bar *bar = (Bar *)bars.At(i);
        delete bar;
    }
    delete bars;
}

void TestIsNotPinbar()
{
    // Init
    CArrayObj *bars = new CArrayObj();
    PopulateBars(*bars);

    // Test Pinbar
    PinbarMatcher matcher;
    matcher.SetBars(*bars);
    bool isPinbar = matcher.IsMatch(1); // 1 (bar2) is not a pinbar
    if (isPinbar)
        Print("[FAIL] Pinbar test failed");
    else
        Print("[PASS] Pinbar test passed");

    // Cleanup
    for (int i = 0; i < bars.Total(); ++i)
    {
        Bar *bar = (Bar *)bars.At(i);
        delete bar;
    }
    delete bars;
}

void OnStart()
{
    TestIsPinbar();
    TestIsNotPinbar();
}

void PopulateBars(CArrayObj &bars)
{
    Bar *bar3 = new Bar(); // bearish
    bar3.high = 8;
    bar3.close = 3;
    bar3.open = 7;
    bar3.low = 2;
    bars.Add(bar3);

    Bar *bar2 = new Bar(); // bullish
    bar2.high = 9;
    bar2.close = 7;
    bar2.open = 4;
    bar2.low = 3;
    bars.Add(bar2);

    Bar *bar1 = new Bar(); // bulllish - Is Pinbar (as per configs in PinbarMatcher.mqh)
    bar1.high = 10;
    bar1.close = 4;
    bar1.open = 2;
    bar1.low = 1.5;
    bars.Add(bar1);

    Bar *bar0 = new Bar(); // bullish
    bar0.high = 3;
    bar0.close = 2;
    bar0.open = 1;
    bar0.low = 0;
    bars.Add(bar0);
}
