#include <Arrays\ArrayObj.mqh>
#include "../Include/lex/Lexer.mqh"

void OnStart()
{
    string query = "I+f?P*f>B+"; // Test input string for TradeQL
    Lexer lexer(query);
    CArrayObj *tokens = lexer.GetTokens();

    PrintFormat("Query: %s", query);
    for (int i = 0; i < tokens.Total(); i++)
    {
        Token *token = (Token *)tokens.At(i);
        Print(TokenToString(token.GetType()));
    }
}

string TokenToString(TokenType t)
{
    switch (t)
    {
    case TOKEN_IMBALANCE:
        return "I";
    case TOKEN_BAR:
        return "B";
    case TOKEN_PINBAR:
        return "P";
    case TOKEN_FORWARD:
        return "f";
    case TOKEN_REVERSE:
        return "r";
    case TOKEN_ZERO_OR_MORE:
        return "*";
    case TOKEN_ONE_OR_MORE:
        return "+";
    case TOKEN_ALTERNATION:
        return "|";
    case TOKEN_GROUP_OPEN:
        return "(";
    case TOKEN_GROUP_CLOSE:
        return ")";
    case TOKEN_SEQUENCE:
        return ">";
    case TOKEN_END:
        return "End of input";
    default:
        return "<unknown>";
    }
}