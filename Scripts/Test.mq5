

bool MyCustomPinbarFunction(int index)
{
    // Custom logic for pinbar
    return true;
}

void OnStart()
{
    // ... initialize TradeQL and bars ...

    tradeQL.SetCustomPinbarFunction(MyCustomPinbarFunction);
}
