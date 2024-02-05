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
    ASTNode *node;
    PatternMatcher *imbMatcher;
    PatternMatcher *pinMatcher;

public:
    TradeQL(string query, PatternMatcher *imbalanceMatcher = NULL, PatternMatcher *pinbarMatcher = NULL) : imbMatcher(imbalanceMatcher), pinMatcher(pinbarMatcher)
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
        node = parser.Parse();
        if (node == NULL)
        {
            Print("WARNING: No ASTNode returned");
            delete tokens;
            delete node;
            return;
        }
    }

    ~TradeQL()
    {
        if (node != NULL)
            delete node;
    }

    void Match(CArrayObj *bars, Trend trend, CArrayObj *matches)
    {
        if (this.node == NULL)
        {
            Print("WARNING: No ASTNode found");
            return;
        }

        // Run the parsed AST against the list of bars
        Matcher matcher(bars, trend, this.imbMatcher, this.pinMatcher);
        matcher.IsMatch(this.node, matches);
    }
};
