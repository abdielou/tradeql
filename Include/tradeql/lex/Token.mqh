#include <Arrays\ArrayObj.mqh>

enum TokenType
{
    TOKEN_IMBALANCE,    // I
    TOKEN_BAR,          // B
    TOKEN_PINBAR,       // P
    TOKEN_FORWARD,      // f
    TOKEN_REVERSE,      // r
    TOKEN_ZERO_OR_MORE, // *
    TOKEN_ONE_OR_MORE,  // +
    TOKEN_EXACTLY_N,    // {n}
    TOKEN_FORWARD_CONS, // C+f
    TOKEN_REVERSE_CONS, // C+r
    TOKEN_NEUTRAL_CONS, // C+
    TOKEN_ALTERNATION,  // |
    TOKEN_GROUP_OPEN,   // (
    TOKEN_NO_CAP_Q,     // ?
    TOKEN_NO_CAP_C,     // :
    TOKEN_GROUP_CLOSE,  // )
    TOKEN_SEQUENCE,     // >
    TOKEN_NUMBER,       // 0-9
    TOKEN_COMMA,        // ,
    TOKEN_END           // End of input
};

class Token : public CObject
{
private:
    TokenType t;
    string v;

public:
    Token(TokenType type, string value = "")
    {
        this.t = type;
        this.v = value;
    }

    TokenType GetType() const
    {
        return t;
    }

    string GetValue() const
    {
        return v;
    }
};
