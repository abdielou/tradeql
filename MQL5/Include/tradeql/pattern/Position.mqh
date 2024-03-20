enum Position
{
    POSITION_BEYOND,
    POSITION_BEHIND,
    POSITION_UNKNOWN
};

Position StringToPosition(string pos)
{
    if (pos == "^")
        return POSITION_BEYOND;
    else if (pos == "_")
        return POSITION_BEHIND;
    else
        return POSITION_UNKNOWN;
}
