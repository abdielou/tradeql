#include <Arrays\ArrayObj.mqh>
#include "Common.mqh"

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
        Print("Imbalance function not implemented");
        return false;
    }

    bool Pinbar(int index)
    {
        if (customPinbarFunction != NULL)
        {
            return customPinbarFunction(this, index);
        }
        Print("Pinbar function not implemented");
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
        Imbalance(0);
        Pinbar(0);
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
};
