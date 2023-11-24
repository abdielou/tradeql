class TqlBar
{
public:
    double open;
    double close;
    double high;
    double low;
};

enum TqlTrend
{
    bullish,
    bearish
};

typedef bool (*PinbarFunction)(int index);
