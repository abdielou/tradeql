#include "../Include/tradeql/Util.mqh"
#include "../Include/tradeql/TradeQL.mqh"

typedef void (*PopulateBarsFunc)(CArrayObj &bars);

void TestPatterns(string query, Trend trend, PopulateBarsFunc populate, string message, bool expect)
{
    // Test bars
    CArrayObj *testBars = new CArrayObj();
    populate(*testBars);

    // Match
    PinbarMatcher *customPinMatcher = new PinbarMatcher(AverageBarSize(*testBars)); // (optional) pinbar matcher with custom average bar size
    TradeQL tradeQL(query, NULL, customPinMatcher);
    CArrayObj *matches = new CArrayObj();
    tradeQL.Match(testBars, trend, matches);

    if (matches.Total() > 0)
    {
        for (int i = 0; i < matches.Total(); ++i)
        {
            Match *match = (Match *)matches.At(i);
            if (match == NULL)
                expect = false;
            else if (match.IsZeroMatch())
                Print("Zero Match");
            else
            {
                Bar *startBar = (Bar *)testBars.At(match.GetStart());
                Bar *endBar = (Bar *)testBars.At(match.GetEnd());
                Print(i == 0 ? "Match: " : "  Sub-Match: ", "[", match.GetEnd(), ",", TimeToString(endBar.time), "] to [", match.GetStart(), ",", TimeToString(startBar.time), "]");
            }
        }
        Print(expect ? "[PASS] " : "[FAIL] ", message, " for ", query);
    }
    else
    {
        Print(expect ? "[FAIL] " : "[PASS] ", message, " for ", query);
    }

    // Cleanup
    for (int i = 0; i < matches.Total(); ++i)
    {
        Match *match = (Match *)matches.At(i);
        delete match;
    }
    delete matches;
    for (int i = 0; i < testBars.Total(); ++i)
    {
        Bar *bar = (Bar *)testBars.At(i);
        delete bar;
    }
    delete testBars;
}

void _OnStart()
{
    // Pattern
    TestPatterns("Bf+", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "SimplePattern 3 bars match", true);
    TestPatterns("Br*", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "SimplePattern zero match", true);
    TestPatterns("Bf+", Trend::TREND_BULLISH, PopulateBarsWithImbalance, "SimplePattern one bar match", true);
    TestPatterns("I", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "SimplePattern no match", false);

    // Pinbar
    TestPatterns("B*>P>B*", Trend::TREND_BULLISH, PopulateBarsWithBullishPinbar, "Pinbar match", true);
    TestPatterns("B*>P>B*", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "Pinbar no match", false);
    TestPatterns("B*>Pf>B*", Trend::TREND_BULLISH, PopulateBarsWithBullishPinbar, "Pinbar forward match", true);
    TestPatterns("B*>Pr>B*", Trend::TREND_BULLISH, PopulateBarsWithBearishPinbar, "Pinbar reverse match", true);

    // Alternation
    TestPatterns("I|B", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "Alternation match", true);

    // Group
    TestPatterns("(Ir+|Bf+)", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "Group match", true);
    TestPatterns("(I|B)*", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "Group zero or more match", true);
    TestPatterns("(I|Br)*", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "Group zero match", true);
    TestPatterns("(I|B)+", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "Group zero or more match", true);
    TestPatterns("(I|Br)+", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "Group zero or more no match", false);

    // Non Capturing Group
    TestPatterns("(?:B)*>(I)+>(?:B)*", Trend::TREND_BULLISH, PopulateBarsWithImbalance, "Non Capturing Group match", true);

    // Position
    TestPatterns("B>(If)>B>(Ir)_>B", Trend::TREND_BULLISH, PopulateBarsWithPosition, "Group with Position match", true);

    // Sequence
    TestPatterns("B>I>B", Trend::TREND_BULLISH, PopulateBarsWithImbalance, "Sequence match", true);
    TestPatterns("B>I>B", Trend::TREND_BULLISH, PopulateBarsWithoutImbalance, "Sequence no match", false);

    // Real Data
    TestPatterns("(?:B)*>(I)+>(?:B)*", Trend::TREND_BULLISH, PopulateBarsWithImbalance, "Real data match", true);
}

void PopulateBarsWithoutImbalance(CArrayObj &bars)
{
    Bar *bar2 = new Bar();
    bar2.high = 7;
    bar2.close = 6;
    bar2.open = 4;
    bar2.low = 2;
    bars.Add(bar2);

    Bar *bar1 = new Bar();
    bar1.high = 5;
    bar1.close = 4;
    bar1.open = 2;
    bar1.low = 1;
    bars.Add(bar1);

    Bar *bar0 = new Bar();
    bar0.high = 3;
    bar0.close = 2;
    bar0.open = 1;
    bar0.low = 0;
    bars.Add(bar0);
}

void PopulateBarsWithImbalance(CArrayObj &bars)
{
    Bar *bar2 = new Bar();
    bar2.high = 7;
    bar2.close = 6;
    bar2.open = 4;
    bar2.low = 3.5;
    bars.Add(bar2);

    Bar *bar1 = new Bar();
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

void PopulateBarsWithPosition(CArrayObj &bars)
{
    Bar *bar4 = new Bar();
    bar4.high = 5;
    bar4.close = 4;
    bar4.open = 2;
    bar4.low = 1;
    bars.Add(bar4);

    Bar *bar3 = new Bar();
    bar3.high = 15;
    bar3.close = 2;
    bar3.open = 14;
    bar3.low = 1;
    bars.Add(bar3);

    Bar *bar2 = new Bar();
    bar2.high = 15;
    bar2.close = 14;
    bar2.open = 12;
    bar2.low = 11;
    bars.Add(bar2);

    Bar *bar1 = new Bar();
    bar1.high = 13;
    bar1.close = 12;
    bar1.open = 7;
    bar1.low = 6;
    bars.Add(bar1);

    Bar *bar0 = new Bar();
    bar0.high = 8;
    bar0.close = 7;
    bar0.open = 5;
    bar0.low = 4;
    bars.Add(bar0);
}

void PopulateBarsWithBearishPinbar(CArrayObj &bars)
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

    Bar *bar1 = new Bar(); // bulllish - Is Pinbar High
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

void PopulateBarsWithBullishPinbar(CArrayObj &bars)
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

    Bar *bar1 = new Bar(); // bulllish - Is Pinbar Low
    bar1.high = 10;
    bar1.close = 9;
    bar1.open = 8;
    bar1.low = 1.5;
    bars.Add(bar1);

    Bar *bar0 = new Bar(); // bullish
    bar0.high = 3;
    bar0.close = 2;
    bar0.open = 1;
    bar0.low = 0;
    bars.Add(bar0);
}

void PopulateBarsWithRealData(CArrayObj &bars)
{
    int count = 20;
    for (int i = 0; i < count; ++i)
    {
        Bar *bar = new Bar();
        bar.high = iHigh(Symbol(), Period(), i);
        bar.close = iClose(Symbol(), Period(), i);
        bar.open = iOpen(Symbol(), Period(), i);
        bar.low = iLow(Symbol(), Period(), i);
        bar.time = iTime(Symbol(), Period(), i);
        bars.Add(bar);
    }
}

double AverageBarSize(CArrayObj &bars)
{
    double sum = 0;
    int count = bars.Total();
    for (int i = 0; i < count; ++i)
    {
        Bar *bar = (Bar *)bars.At(i);
        sum += bar.high - bar.low;
    }
    return sum / count;
}
