enum Pattern
{
    PATTERN_IMBALANCE,
    PATTERN_BAR,
    PATTERN_PINBAR,
    PATTERN_UNKNOWN
};

Pattern StringToPattern(string pattern)
{
    if (pattern == "I")
        return PATTERN_IMBALANCE;
    else if (pattern == "B")
        return PATTERN_BAR;
    else if (pattern == "P")
        return PATTERN_PINBAR;
    else
        return PATTERN_UNKNOWN;
}
