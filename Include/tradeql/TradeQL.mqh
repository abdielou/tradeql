#include <Arrays\ArrayObj.mqh>
#include "Common.mqh"
#include "bar/Match.mqh"
#include "bar/Trend.mqh"
#include "lex/Lexer.mqh"
#include "parse/Parser.mqh"
#include "match/Matcher.mqh"

class TradeQL
{
private:
    CArrayObj *bars;
    Trend trend;
    PatternMatcher *imbMatcher;
    PatternMatcher *pinMatcher;

public:
    TradeQL(CArrayObj *pbars, Trend ptrend, PatternMatcher *imbalanceMatcher = NULL, PatternMatcher *pinbarMatcher = NULL) : bars(pbars), trend(ptrend), imbMatcher(imbalanceMatcher), pinMatcher(pinbarMatcher) {}

    void Match(string query, CArrayObj *matches)
    {
        // Tokenize the query
        Lexer lexer(query);
        CArrayObj *tokens = lexer.GetTokens();
        if (tokens.Total() == 0)
        {
            Print("WARNING: No tokens found");
            return;
        }

        // Parse the tokens into an AST
        Parser parser(tokens);
        ASTNode *node = parser.Parse();
        if (node == NULL)
        {
            Print("WARNING: No ASTNode returned");
            delete tokens;
            delete node;
            return;
        }

        // Run the parsed AST against the list of bars
        Matcher matcher(this.bars, this.trend, this.imbMatcher, this.pinMatcher);
        matcher.IsMatch(node, matches);
        delete node;
    }
};
