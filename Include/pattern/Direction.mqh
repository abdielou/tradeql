enum Direction
{
    DIRECTION_FORWARD,
    DIRECTION_REVERSE,
    DIRECTION_UNKNOWN
};

Direction StringToDirection(string dir)
{
    if (dir == "f")
        return DIRECTION_FORWARD;
    else if (dir == "r")
        return DIRECTION_REVERSE;
    else
        return DIRECTION_UNKNOWN;
}
