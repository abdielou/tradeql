#include <Arrays\ArrayObj.mqh>
#include "Token.mqh"

class Lexer
{
private:
    string inputString;
    int position;
    CArrayObj *tokens;

    void AddToken(TokenType type, string value = "")
    {
        Token *token = new Token(type, value);
        tokens.Add(token);
    }

    char Peek() const
    {
        if (position < StringLen(inputString))
            return (char)StringGetCharacter(inputString, position);
        return '\0';
    }

    char NextChar()
    {
        if (position < StringLen(inputString))
            return (char)StringGetCharacter(inputString, position++);
        return '\0';
    }

    bool Tokenize()
    {
        bool unknownTokenEncountered = false;

        while (position < StringLen(inputString))
        {
            char c = NextChar();

            switch (c)
            {
            case 'I':
                AddToken(TOKEN_IMBALANCE, (string)c);
                break;
            case 'B':
                AddToken(TOKEN_BAR, (string)c);
                break;
            case 'P':
                AddToken(TOKEN_PINBAR, (string)c);
                break;
            case 'f':
                AddToken(TOKEN_FORWARD, (string)c);
                break;
            case 'r':
                AddToken(TOKEN_REVERSE, (string)c);
                break;
            case '*':
                AddToken(TOKEN_ZERO_OR_MORE, (string)c);
                break;
            case '+':
                AddToken(TOKEN_ONE_OR_MORE, (string)c);
                break;
            case '|':
                AddToken(TOKEN_ALTERNATION, (string)c);
                break;
            case '(':
                AddToken(TOKEN_GROUP_OPEN, (string)c);
                break;
            case ')':
                AddToken(TOKEN_GROUP_CLOSE, (string)c);
                break;
            case '>':
                AddToken(TOKEN_SEQUENCE, (string)c);
                break;
            // Unknown or not implemented yet
            // case '{':
            // case '}':
            // case '0-9':
            default:
                unknownTokenEncountered = true;
                Print("Not implemented or unknown token ", c, " at position ", position, " in ", inputString);
                break;
            }
        }

        if (unknownTokenEncountered)
        {
            ClearTokens();
            return false;
        }
        else
        {
            AddToken(TOKEN_END);
            return true;
        }
    }

    void ClearTokens()
    {
        for (int i = 0; i < tokens.Total(); i++)
        {
            delete tokens.At(i);
        }
        tokens.Clear();
    }

public:
    Lexer(const string str)
    {
        this.inputString = str;
        position = 0;
        tokens = new CArrayObj();
        if (!Tokenize())
            Print("Tokenization failed due to unknown tokens.");
    }

    ~Lexer()
    {
        for (int i = 0; i < tokens.Total(); i++)
        {
            delete tokens.At(i);
        }
        delete tokens;
    }

    CArrayObj *GetTokens() const
    {
        return tokens;
    }
};
