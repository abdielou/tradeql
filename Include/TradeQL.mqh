#include <Arrays\ArrayObj.mqh>
#include "Common.mqh"

class TradeQL
{
private:
    CArrayObj *bars[];
    TqlTrend trend;

    PinbarFunction customPinbarFunction;

    bool Imbalance(int index)
    {
        return false;
    }

    bool Pinbar(int index)
    {
        if (customPinbarFunction != NULL)
        {
            return customPinbarFunction(index);
        }
        // ExpertLastError("Custom pinbar function not set");
        return false;
    }

    TqlTrend GetTrend()
    {
        return trend;
    }

public:
    TradeQL(CArrayObj &pbars[], TqlTrend ptrend)
    {
        this.bars = pbars;
        this.trend = ptrend;
    }

    CArrayObj *Match(string query)
    {
        return NULL;
    }

    void SetCustomPinbarFunction(PinbarFunction func)
    {
        customPinbarFunction = func;
    }

    TqlBar *GetBar(int index)
    {
        return bars[index];
    }
};
