#include <Arrays\ArrayObj.mqh>
#include "Common.mqh"
#include "./bar/Match.mqh"
#include "./bar/Trend.mqh"
#include "./lex/Lexer.mqh"
#include "./parse/Parser.mqh"
#include "./match/Matcher.mqh"

class TradeQL
{
private:
    CArrayObj *bars;
    Trend trend;

public:
    TradeQL(CArrayObj &pbars, Trend ptrend)
    {
        this.bars = &pbars;
        this.trend = ptrend;
    }

    void Match(string query, Match &match)
    {
        // Tokenize the query
        Lexer *lexer = new Lexer(query);
        CArrayObj *tokens = lexer.GetTokens();
        if (tokens.Total() == 0)
        {
            Print("WARNING: No tokens found");
            return;
        }

        // Parse the tokens into an AST
        Parser parser(tokens);
        ASTNode *result = parser.Parse();
        if (result == NULL)
        {
            Print("WARNING: No ASTNode returned");
            return;
        }

        // Run the parsed AST against the list of bars
        Matcher matcher(this.bars, this.trend);
        // TODO

        // Return matches and groups
        // TODO
    }
};
