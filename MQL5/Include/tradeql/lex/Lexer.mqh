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
                AddToken(TOKEN_IMBALANCE, ShortToString(c));
                break;
            case 'B':
                AddToken(TOKEN_BAR, ShortToString(c));
                break;
            case 'P':
                AddToken(TOKEN_PINBAR, ShortToString(c));
                break;
            case 'f':
                AddToken(TOKEN_FORWARD, ShortToString(c));
                break;
            case 'r':
                AddToken(TOKEN_REVERSE, ShortToString(c));
                break;
            case '*':
                AddToken(TOKEN_ZERO_OR_MORE, ShortToString(c));
                break;
            case '+':
                AddToken(TOKEN_ONE_OR_MORE, ShortToString(c));
                break;
            case '|':
                AddToken(TOKEN_ALTERNATION, ShortToString(c));
                break;
            case '(':
                AddToken(TOKEN_GROUP_OPEN, ShortToString(c));
                break;
            case ')':
                AddToken(TOKEN_GROUP_CLOSE, ShortToString(c));
                break;
            case '?':
                AddToken(TOKEN_NO_CAP_Q, ShortToString(c));
                break;
            case ':':
                AddToken(TOKEN_NO_CAP_C, ShortToString(c));
                break;
            case '>':
                AddToken(TOKEN_SEQUENCE, ShortToString(c));
                break;
            case '^':
                AddToken(TOKEN_BEYOND, ShortToString(c));
                break;
            case '_':
                AddToken(TOKEN_BEHIND, ShortToString(c));
                break;
            // Unknown or not implemented yet
            // case '{':
            // case '}':
            // case '0-9':
            default:
                unknownTokenEncountered = true;
                Print("Not implemented or unknown token ", ShortToString(c), " at position ", position, " in ", inputString);
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
