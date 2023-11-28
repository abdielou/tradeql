#include "../Parser.mqh"
#include "../ast/PatternNode.mqh"
#include "../../lex/Token.mqh"

ASTNode *ParseBasicExpr(Parser &parser)
{
    Token *currentToken = parser.GetCurrentToken();

    // Check for Pattern
    if (currentToken != NULL && parser.IsTokenPattern(currentToken.GetType()))
    {
        PatternNode *patternNode = new PatternNode(currentToken.GetValue());
        parser.AdvanceToken();

        // Optional Direction
        currentToken = parser.GetCurrentToken();
        if (currentToken != NULL && parser.IsTokenDirection(currentToken.GetType()))
        {
            patternNode.SetDirection(currentToken.GetValue());
            parser.AdvanceToken();
        }

        // Optional Quantifier
        currentToken = parser.GetCurrentToken();
        if (currentToken != NULL && parser.IsTokenQuantifier(currentToken.GetType()))
        {
            patternNode.SetQuantifier(currentToken.GetValue());
            parser.AdvanceToken();
        }

        return patternNode;
    }

    return NULL;
}
