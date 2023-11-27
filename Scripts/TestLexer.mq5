#include <Arrays\ArrayObj.mqh>
#include "../Include/lex/Lexer.mqh"

void OnStart()
{
    const string query = GetTestQuery();
    CArrayObj *expected = new CArrayObj();
    GetTestTokens(expected);

    Lexer *lexer = new Lexer(query);
    CArrayObj *tokens = lexer.GetTokens();

    // Assert
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
    Print("[PASS] Lexer test passed");

    // Cleanup
    delete expected;
    delete lexer;
    delete tokens;
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