#include <Arrays\ArrayObj.mqh>
#include "../Include/lex/Lexer.mqh"

void OnStart()
{
    const string validQuery = GetTestQuery();
    const string invalidQuery = "X";

    CArrayObj *expected = new CArrayObj();
    GetTestTokens(expected);

    Lexer *lexer = new Lexer(validQuery);
    CArrayObj *tokens = lexer.GetTokens();

    // Assert valid query
    for (int i = 0; i < tokens.Total(); i++)
    {
        Token *token = (Token *)tokens.At(i);
        Token *expectedToken = (Token *)expected.At(i);
        if (token.GetType() != expectedToken.GetType())
        {
            Print("[FAIL] Lexer test failed at index ", i);
            return;
        }
    }

    // Assert invalid query
    Lexer *invalidLexer = new Lexer(invalidQuery);
    CArrayObj *invalidTokens = invalidLexer.GetTokens();
    if (invalidTokens.Total() != 0)
    {
        Print("[FAIL] Lexer test failed at invalid query");
        return;
    }

    Print("[PASS] Lexer test passed");

    // Cleanup
    delete expected;
    delete lexer;
    delete invalidLexer;
    delete tokens;
    delete invalidTokens;
}

string GetTestQuery()
{
    return "I+f>P*f>B+";
}

void GetTestTokens(CArrayObj &tokens)
{
    tokens.Add(new Token(TOKEN_IMBALANCE));    // I
    tokens.Add(new Token(TOKEN_ONE_OR_MORE));  // +
    tokens.Add(new Token(TOKEN_FORWARD));      // f
    tokens.Add(new Token(TOKEN_SEQUENCE));     // >
    tokens.Add(new Token(TOKEN_PINBAR));       // P
    tokens.Add(new Token(TOKEN_ZERO_OR_MORE)); // *
    tokens.Add(new Token(TOKEN_FORWARD));      // f
    tokens.Add(new Token(TOKEN_SEQUENCE));     // >
    tokens.Add(new Token(TOKEN_BAR));          // B
    tokens.Add(new Token(TOKEN_ONE_OR_MORE));  // +
    tokens.Add(new Token(TOKEN_END));          // End of input
}