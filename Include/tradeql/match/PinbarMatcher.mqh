#include "PatternMatcher.mqh"

class PinbarMatcher : public PatternMatcher
{
private:
    double PinMinRatio;
    double PinMinBarSizePctg;
    double BarAverageSize;

    bool CalculatePin(int index, bool &isRejectedHigh)
    {
        // Measure high pin and low pin
        Bar *target = GetBar(index);
        bool isBullish = target.close > target.open;
        double highPin = isBullish ? target.high - target.close : target.high - target.open;
        double lowPin = isBullish ? target.open - target.low : target.close - target.low;
        double body = isBullish ? target.close - target.open : target.open - target.close;
        body += highPin + lowPin;
        if (body <= 0)
            return false;

        // Calculate pinbar ratio
        double highRatio = highPin / body;
        double lowRatio = lowPin / body;
        isRejectedHigh = highRatio > lowRatio;
        double ratio = isRejectedHigh ? highRatio : lowRatio;

        // Validate
        bool hasRatio = ratio >= PinMinRatio;
        bool hasSize = BarAverageSize > 0 ? body >= BarAverageSize * PinMinBarSizePctg : true;
        return hasRatio && hasSize;
    }

public:
    /**
     * Pinbar matcher
     *
     * @param avgSize : Average size of bars (not used if not available)
     * @param ratio : Minimum wick to body ratio
     * @param targetSize : Minimum size of bar's body compared to average
     */
    PinbarMatcher(double avgSize = 0, double ratio = 0.60, double targetSize = 1.2) : PatternMatcher()
    {
        PinMinRatio = ratio;
        PinMinBarSizePctg = targetSize;
        BarAverageSize = avgSize;
    }
    virtual bool IsMatch(const int index) override
    {
        bool isRejectedHigh;
        return CalculatePin(index, isRejectedHigh);
    }
    bool IsMatch(const int index, bool &isRejectedHigh)
    {
        return CalculatePin(index, isRejectedHigh);
    }
};
