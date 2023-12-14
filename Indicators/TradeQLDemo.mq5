//+------------------------------------------------------------------+
//|                                                   TradeQL DEMO   |
//|                                                 Copyright 2023   |
//|                                https://www.mozartanalytics.com   |
//+------------------------------------------------------------------+
#property description "TradeQL Demostrator"
#property copyright "Mozart Analytics FX LLC"
#property link "https://www.mozartanalytics.com"
#property version "1.00"
#property strict
#property indicator_chart_window
#property indicator_plots 0

#include "../Include/tradeql/TradeQL.mqh"

const string InputFieldName = "TradeQLQueryInput";
const string MatchBoxName = "TradeQLMatch";
const string DefaultQuery = "(?:I|B)*>(If)+>B*>(Ir)+>B*>(Ir)+>B*"; // ICT SB
datetime gSelectedTime = 0;
int gBarCount = 20;
Trend gTrend = Trend::TREND_BEARISH;

int OnInit()
{
    // Create input text box
    long chartCenterX = ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS) / 2;
    int boxSize = 350;
    if (ObjectCreate(ChartID(), InputFieldName, OBJ_EDIT, 0, 0, 0))
    {
        ObjectSetInteger(ChartID(), InputFieldName, OBJPROP_XDISTANCE, (int)chartCenterX - (boxSize / 2));
        ObjectSetInteger(ChartID(), InputFieldName, OBJPROP_YDISTANCE, 20);
        ObjectSetInteger(ChartID(), InputFieldName, OBJPROP_XSIZE, boxSize);
        ObjectSetInteger(ChartID(), InputFieldName, OBJPROP_YSIZE, 40);
        ObjectSetString(ChartID(), InputFieldName, OBJPROP_TEXT, DefaultQuery);
        ObjectSetInteger(ChartID(), InputFieldName, OBJPROP_COLOR, clrBlack);
        ObjectSetInteger(ChartID(), InputFieldName, OBJPROP_BGCOLOR, clrWhiteSmoke);
        ObjectSetInteger(ChartID(), InputFieldName, OBJPROP_BORDER_COLOR, clrNONE);
        ObjectSetInteger(ChartID(), InputFieldName, OBJPROP_FONTSIZE, 15);
    }

    return INIT_SUCCEEDED;
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    return rates_total;
}

void OnDeinit(const int reason)
{
    ObjectDelete(ChartID(), InputFieldName);
    ObjectsDeleteAll(ChartID(), MatchBoxName);
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
    if (id == CHARTEVENT_CLICK)
    {
        // Get selected time
        int window;
        datetime time;
        double price = -1;
        if (ChartXYToTimePrice(ChartID(), (int)lparam, (int)dparam, window, time, price))
            gSelectedTime = time;

        // Find bar at selected time
        int selectedBarIndex = iBarShift(Symbol(), 0, gSelectedTime, false);

        // Get Query
        string query = ObjectGetString(ChartID(), InputFieldName, OBJPROP_TEXT);

        // Load bars
        CArrayObj *bars = new CArrayObj();
        PopulateBars(selectedBarIndex, bars, gBarCount);

        // Match
        TradeQL tradeQL(bars, gTrend, NULL, new DummyPinbarMatcher());
        CArrayObj *matches = new CArrayObj();
        tradeQL.Match(query, matches);

        // Draw matches
        ObjectsDeleteAll(ChartID(), MatchBoxName);
        if (matches.Total() > 0)
        {
            for (int i = 0; i < matches.Total(); ++i)
            {
                Match *match = (Match *)matches.At(i);
                if (match != NULL && !match.IsZeroMatch())
                {
                    PrintMatch(match, bars, i);
                    DrawMatch(match, bars, i);
                }
            }
        }
        else
            DrawNoMatch(selectedBarIndex, selectedBarIndex + gBarCount);

        // Cleanup
        for (int i = 0; i < matches.Total(); ++i)
        {
            Match *match = (Match *)matches.At(i);
            delete match;
        }
        delete matches;
        for (int i = 0; i < bars.Total(); ++i)
        {
            Bar *bar = (Bar *)bars.At(i);
            delete bar;
        }
        delete bars;
    }
    ChartRedraw(ChartID());
}

void PopulateBars(const int selectedBarIndex, CArrayObj *bars, const int barsToLoad = 10)
{
    int startIdx = selectedBarIndex - barsToLoad > 0 ? selectedBarIndex - barsToLoad + 1 : 0;
    int endIdx = selectedBarIndex;
    for (int i = startIdx; i <= endIdx; ++i)
    {
        Bar *bar = new Bar();
        bar.open = iOpen(Symbol(), Period(), i);
        bar.high = iHigh(Symbol(), Period(), i);
        bar.low = iLow(Symbol(), Period(), i);
        bar.close = iClose(Symbol(), Period(), i);
        bar.time = iTime(Symbol(), Period(), i);
        bars.Add(bar);
    }
}

void PrintMatch(Match *match, CArrayObj *bars, int i)
{
    Bar *startBar = (Bar *)bars.At(match.GetStart());
    int startBarIndex = iBarShift(Symbol(), 0, startBar.time, false);
    Bar *endBar = (Bar *)bars.At(match.GetEnd());
    int endBarIndex = iBarShift(Symbol(), 0, endBar.time, false);
    Print(!match.IsGroupMatch() ? "Match: " : "  Sub-Match: ", "[", startBarIndex, ",", TimeToString(startBar.time), "] to [", endBarIndex, ",", TimeToString(endBar.time), "]");
}

void DrawMatch(Match *match, CArrayObj *bars, int i)
{
    // Get times and prices
    bool isGroupMatch = match.IsGroupMatch();
    Bar *startBar = (Bar *)bars.At(match.GetStart());
    int timeStartBarIndex = iBarShift(Symbol(), 0, startBar.time, false) + (isGroupMatch ? 1 : 0);
    timeStartBarIndex = timeStartBarIndex < 0 ? 0 : timeStartBarIndex;
    int priceStartBarIndex = iBarShift(Symbol(), 0, startBar.time, false);
    priceStartBarIndex = priceStartBarIndex < 0 ? 0 : priceStartBarIndex;
    Bar *endBar = (Bar *)bars.At(match.GetEnd());
    int timeEndBarIndex = iBarShift(Symbol(), 0, endBar.time, false) - (isGroupMatch ? 1 : 0);
    timeEndBarIndex = timeEndBarIndex < 0 ? 0 : timeEndBarIndex;
    int priceEndBarIndex = iBarShift(Symbol(), 0, endBar.time, false);
    priceEndBarIndex = priceEndBarIndex < 0 ? 0 : priceEndBarIndex;

    datetime time1 = iTime(Symbol(), Period(), timeEndBarIndex);
    double price1 = iHigh(Symbol(), Period(), iHighest(Symbol(), Period(), MODE_HIGH, priceStartBarIndex - priceEndBarIndex + 1, priceEndBarIndex));
    datetime time2 = iTime(Symbol(), Period(), timeStartBarIndex);
    double price2 = iLow(Symbol(), Period(), iLowest(Symbol(), Period(), MODE_LOW, priceStartBarIndex - priceEndBarIndex + 1, priceEndBarIndex));

    // Draw rectangle
    string rectangleName = MatchBoxName + IntegerToString(i);
    if (ObjectCreate(ChartID(), rectangleName, OBJ_RECTANGLE, 0, time2, price2, time1, price1))
        ObjectSetInteger(ChartID(), rectangleName, OBJPROP_COLOR, isGroupMatch ? clrRed : clrBlue);
}

void DrawNoMatch(int startIndex, int endIndex)
{
    if (gSelectedTime == 0)
        return;

    int endBarIndex = iBarShift(Symbol(), 0, gSelectedTime, false);
    endBarIndex = endBarIndex < 0 ? 0 : endBarIndex;
    int startBarIndex = endBarIndex - gBarCount + 1;
    startBarIndex = startBarIndex < 0 ? 0 : startBarIndex;

    datetime time1 = iTime(Symbol(), Period(), endBarIndex);
    double price1 = iHigh(Symbol(), Period(), iHighest(Symbol(), Period(), MODE_HIGH, endBarIndex - startBarIndex + 1, startBarIndex));
    datetime time2 = iTime(Symbol(), Period(), startBarIndex);
    double price2 = iLow(Symbol(), Period(), iLowest(Symbol(), Period(), MODE_LOW, endBarIndex - startBarIndex + 1, startBarIndex));

    // Draw rectangle
    string rectangleName = MatchBoxName + "NoMatch";
    if (ObjectCreate(ChartID(), rectangleName, OBJ_RECTANGLE, 0, time1, price1, time2, price2))
        ObjectSetInteger(ChartID(), rectangleName, OBJPROP_COLOR, clrBlack);
}

class DummyPinbarMatcher : public PatternMatcher
{
public:
    DummyPinbarMatcher() : PatternMatcher() {}
    bool IsMatch(const int index)
    {
        return false;
    }
};
