#include <Arrays\ArrayObj.mqh>
#include "../Common.mqh"
#include "../lex/Token.mqh"
#include "./ast/ASTNode.mqh"
#include "./grammar/ParseBasicExpr.mqh"

class Parser
{
private:
    CArrayObj *tokenList;
    int pos;
    ParseBasicExprFunction parseBasicExpr;

    // Top Level Rule
    ASTNode *ParseSequenceExpr()
    {
        // TODO
        return NULL;
    }

public:
    Parser(CArrayObj *tokens) : tokenList(tokens), pos(0)
    {
        parseBasicExpr = ParseBasicExpr;
    }

    ASTNode *Parse()
    {
        return ParseSequenceExpr();
    }

    // Helpers
    Token *GetCurrentToken()
    {
        if (pos < tokenList.Total())
            return (Token *)tokenList.At(pos);
        return NULL;
    }
    Token *AdvanceToken()
    {
        if (pos < tokenList.Total())
            return (Token *)tokenList.At(pos++);
        return NULL;
    }
    bool IsTokenPattern(TokenType type)
    {
        return type == TOKEN_IMBALANCE || type == TOKEN_BAR || type == TOKEN_PINBAR;
    }
    bool IsTokenDirection(TokenType type)
    {
        return type == TOKEN_FORWARD || type == TOKEN_REVERSE;
    }
    bool IsTokenQuantifier(TokenType type)
    {
        return type == TOKEN_ZERO_OR_MORE || type == TOKEN_ONE_OR_MORE;
    }
};
