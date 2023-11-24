#include <Arrays\ArrayObj.mqh>

class TradeQL; // Forward declaration

class TqlBar : public CObject
{
public:
    double open;
    double close;
    double high;
    double low;
};

class TqlMatch
{
public:
    int startIndex;
    int endIndex;
};

enum TqlTrend
{
    bullish,
    bearish
};

typedef bool (*ImbalanceFunction)(TradeQL &tradeQL, int index);
typedef bool (*PinbarFunction)(TradeQL &tradeQL, int index);
