#include <Arrays\ArrayObj.mqh>
#include "../Common.mqh"
#include "../lex/Token.mqh"
#include "./ast/ASTNode.mqh"
#include "./ast/PatternNode.mqh"
#include "./ast/AltExprNode.mqh"
#include "./ast/GroupNode.mqh"

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

    // Top Level Rule
    ASTNode *ParseSequenceExpr()
    {
        // TODO
        return ParseExpression();
    }

public:
    Parser(CArrayObj *tokens) : tokenList(tokens), pos(0) {}

    ASTNode *Parse()
    {
        return ParseSequenceExpr();
    }

    // Expression Rules
    ASTNode *ParseBasicExpr()
    {
        Token *currentToken = GetCurrentToken();

        // Check for Pattern
        if (currentToken != NULL && IsTokenPattern(currentToken.GetType()))
        {
            PatternNode *patternNode = new PatternNode(currentToken.GetValue());
            AdvanceToken(); // Consume the 'Direction' or Quantifier token

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

    ASTNode *ParseAltExpr()
    {
        AltExprNode *altExprNode = new AltExprNode();
        ASTNode *exprNode = NULL;

        do
        {
            exprNode = ParseBasicExpr();
            if (exprNode != NULL)
            {
                altExprNode.AddExpression(exprNode);
            }

            if (GetCurrentToken() != NULL && GetCurrentToken().GetType() == TOKEN_ALTERNATION)
            {
                AdvanceToken(); // Consume the '|' token
            }
            else
            {
                break;
            }
        } while (true);

        return altExprNode.GetExpressions().Total() > 0 ? altExprNode : NULL;
    }

    ASTNode *ParseGroup()
    {
        Token *currentToken = GetCurrentToken();

        if (currentToken != NULL && currentToken.GetType() == TOKEN_GROUP_OPEN)
        {
            AdvanceToken(); // Consume the '(' token

            ASTNode *innerExpr = ParseAltExpr();

            currentToken = GetCurrentToken();
            if (currentToken != NULL && currentToken.GetType() == TOKEN_GROUP_CLOSE)
            {
                AdvanceToken(); // Consume the ')' token

                // Optional Quantifier
                string quantifier = "";
                currentToken = GetCurrentToken();
                if (currentToken != NULL && IsTokenQuantifier(currentToken.GetType()))
                {
                    quantifier = currentToken.GetValue();
                    AdvanceToken();
                }

                return new GroupNode(innerExpr, quantifier);
            }
        }

        return NULL;
    }

    ASTNode *ParseExpression()
    {
        Token *currentToken = GetCurrentToken();

        if (currentToken != NULL)
        {
            // Check for '(' to parse as Group
            if (currentToken.GetType() == TOKEN_GROUP_OPEN)
            {
                return ParseGroup();
            }
            else
            {
                // If not a Group, parse as AltExpr
                return ParseAltExpr();
            }
        }

        return NULL;
    }
};
