//+------------------------------------------------------------------+
//|                                                        TradeQL   |
//|                                                 Copyright 2023   |
//|                                https://www.mozartanalytics.com   |
//+------------------------------------------------------------------+
#property description "TradeQL: Regex like DSL for trading patterns"
#property copyright "Mozart Analytics FX LLC"
#property link "https://www.mozartanalytics.com"
#property icon "\\Images\\abdielou\\mozart.ico"
#property version "1.00"
#property strict

#include <Arrays\ArrayObj.mqh>
#include "../Include/Common.mqh"
#include "../Include/bar/Match.mqh"
#include "../Include/bar/Trend.mqh"
#include "../Include/lex/Lexer.mqh"
#include "../Include/parse/Parser.mqh"
#include "../Include/match/Matcher.mqh"

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
