#include <Arrays\ArrayObj.mqh>
#include "../Common.mqh"
#include "../lex/Token.mqh"
#include "./ast/ASTNode.mqh"
#include "./ast/PatternNode.mqh"

class Parser
{
private:
    CArrayObj *tokenList;
    int pos;

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

    // Expression Rules
    ASTNode *ParseBasicExpr()
    {
        Token *currentToken = GetCurrentToken();

        // Check for Pattern
        if (currentToken != NULL && IsTokenPattern(currentToken.GetType()))
        {
            PatternNode *patternNode = new PatternNode(currentToken.GetValue());
            AdvanceToken();

            // Optional Direction
            currentToken = GetCurrentToken();
            if (currentToken != NULL && IsTokenDirection(currentToken.GetType()))
            {
                patternNode.SetDirection(currentToken.GetValue());
                AdvanceToken();
            }

            // Optional Quantifier
            currentToken = GetCurrentToken();
            if (currentToken != NULL && IsTokenQuantifier(currentToken.GetType()))
            {
                patternNode.SetQuantifier(currentToken.GetValue());
                AdvanceToken();
            }

            return patternNode;
        }

        return NULL;
    }

    // Top Level Rule
    ASTNode *ParseSequenceExpr()
    {
        // TODO
        return ParseBasicExpr();
    }

public:
    Parser(CArrayObj *tokens) : tokenList(tokens), pos(0) {}

    ASTNode *Parse()
    {
        return ParseSequenceExpr();
    }
};
