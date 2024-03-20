enum Quantifier
{
    QUANTIFIER_ONE_OR_MORE,
    QUANTIFIER_ZERO_OR_MORE,
    QUANTIFIER_UNKNOWN
};

Quantifier StringToQuantifier(string quant)
{
    if (quant == "+")
        return QUANTIFIER_ONE_OR_MORE;
    else if (quant == "*")
        return QUANTIFIER_ZERO_OR_MORE;
    else
        return QUANTIFIER_UNKNOWN;
}
