#include <Arrays\ArrayObj.mqh>
#include "../Include/lex/Lexer.mqh"

void OnStart()
{
    const string validQuery = GetTestQuery();
    const string invalidQuery = "X";

    CArrayObj *expected = new CArrayObj();
    GetTestTokens(expected);

    Lexer lexer(validQuery);
    CArrayObj *tokens = lexer.GetTokens();

    // Assert valid query
    bool passAllTokens = true;
    for (int i = 0; i < tokens.Total(); i++)
    {
        Token *token = (Token *)tokens.At(i);
        Token *expectedToken = (Token *)expected.At(i);
        if (token.GetType() != expectedToken.GetType())
        {
            Print("[FAIL] Lexer test failed at index ", i);
            passAllTokens = false;
            break;
        }
    }
    if (passAllTokens)
        Print("[PASS] Lexer test passed for valid query with ", tokens.Total(), " tokens");

    // Assert invalid query
    Lexer invalidLexer(invalidQuery);
    CArrayObj *invalidTokens = invalidLexer.GetTokens();
    if (invalidTokens.Total() != 0)
        Print("[FAIL] Lexer test failed at invalid query");
    else
        Print("[PASS] Lexer test passed for invalid query");

    // Cleanup
    delete expected;
}

string GetTestQuery()
{
    return "If+>Pf*>B+";
}

void GetTestTokens(CArrayObj &tokens)
{
    tokens.Add(new Token(TOKEN_IMBALANCE));    // I
    tokens.Add(new Token(TOKEN_FORWARD));      // f
    tokens.Add(new Token(TOKEN_ONE_OR_MORE));  // +
    tokens.Add(new Token(TOKEN_SEQUENCE));     // >
    tokens.Add(new Token(TOKEN_PINBAR));       // P
    tokens.Add(new Token(TOKEN_FORWARD));      // f
    tokens.Add(new Token(TOKEN_ZERO_OR_MORE)); // *
    tokens.Add(new Token(TOKEN_SEQUENCE));     // >
    tokens.Add(new Token(TOKEN_BAR));          // B
    tokens.Add(new Token(TOKEN_ONE_OR_MORE));  // +
}