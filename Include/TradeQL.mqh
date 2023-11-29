#include <Arrays\ArrayObj.mqh>
#include "Common.mqh"
#include "./bar/TqlBar.mqh"
#include "./bar/TqlMatch.mqh"
#include "./bar/TqlTrend.mqh"

class TradeQL
{
private:
    CArrayObj *bars;
    TqlTrend trend;

    PinbarFunction customPinbarFunction;
    ImbalanceFunction customImbalanceFunction;

    bool Imbalance(int index)
    {
        if (customImbalanceFunction != NULL)
        {
            return customImbalanceFunction(this, index);
        }
        Print("WARNING: Imbalance function not implemented");
        return false;
    }

    bool Pinbar(int index)
    {
        if (customPinbarFunction != NULL)
        {
            return customPinbarFunction(this, index);
        }
        Print("WARNING: Pinbar function not implemented");
        return false;
    }

public:
    TradeQL(CArrayObj &pbars, TqlTrend ptrend)
    {
        this.bars = &pbars;
        this.trend = ptrend;
    }

    void Match(string query, TqlMatch &match)
    {
        // TODO: implement
        Imbalance(1);
        Pinbar(1);
    }

    void SetImbalanceFunc(ImbalanceFunction func)
    {
        customImbalanceFunction = func;
    }

    void SetPinbarFunc(PinbarFunction func)
    {
        customPinbarFunction = func;
    }

    TqlBar *GetBar(int index)
    {
        return bars.At(index);
    }

    TqlTrend GetTrend()
    {
        return trend;
    }

    int GetBarCount()
    {
        return bars.Total();
    }
};
