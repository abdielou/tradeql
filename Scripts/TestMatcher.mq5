#include "../Include/lex/Lexer.mqh"
#include "../Include/parse/Parser.mqh"
#include "../Include/match/Matcher.mqh"
#include "../Include/Util.mqh"

class DummyPinbarMatcher : public PatternMatcher
{
public:
    DummyPinbarMatcher() : PatternMatcher() {}
    bool IsMatch(const int index)
    {
        return false;
    }
};

typedef void (*PopulateBarsFunc)(CArrayObj &bars);

void TestMatcherWithSimpleBarPattern(string query, Trend trend, PopulateBarsFunc populate, string message, bool expect)
{
    CArrayObj *testBars = new CArrayObj();
    populate(*testBars);

    Lexer lexer(query);
    CArrayObj *tokens = lexer.GetTokens();
    Parser parser(tokens);
    ASTNode *node = parser.Parse();

    CArrayObj *matches = new CArrayObj();
    Matcher matcher(testBars, trend, NULL, new DummyPinbarMatcher());
    matcher.IsMatch(node, matches);

    if (matches.Total() > 0)
    {
        for (int i = 0; i < matches.Total(); ++i)
        {
            Match *match = (Match *)matches.At(i);
            if (match == NULL)
                expect = false;
            else
                Print("Match: ", match.GetStart(), " to ", match.GetEnd());
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
    delete node;
}

void OnStart()
{
    TestMatcherWithSimpleBarPattern("Bf+", TREND_BULLISH, PopulateBarsWithoutImbalance, "SimplePattern 3 bars match", true);
    TestMatcherWithSimpleBarPattern("Bf+", TREND_BULLISH, PopulateBarsWithImbalance, "SimplePattern one bar match", true);
    TestMatcherWithSimpleBarPattern("I", TREND_BULLISH, PopulateBarsWithoutImbalance, "SimplePattern no match", false);
    TestMatcherWithSimpleBarPattern("I|B", TREND_BULLISH, PopulateBarsWithoutImbalance, "Alternation match", true);
    TestMatcherWithSimpleBarPattern("(Ir+|Bf+)", TREND_BULLISH, PopulateBarsWithoutImbalance, "Group match", true);
    TestMatcherWithSimpleBarPattern("(I|B)*", TREND_BULLISH, PopulateBarsWithoutImbalance, "Group zero or more match", true);
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
