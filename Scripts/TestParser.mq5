#include <Arrays\ArrayObj.mqh>
#include "../Include/parse/Parser.mqh"

void TestParseBasicExpr()
{
    // Create a mock token list
    CArrayObj *mockTokens = new CArrayObj();
    mockTokens.Add(new Token(TOKEN_IMBALANCE, "I"));
    mockTokens.Add(new Token(TOKEN_FORWARD, "f"));
    mockTokens.Add(new Token(TOKEN_ONE_OR_MORE, "+"));

    // Instantiate the parser with the mock token list
    Parser parser(mockTokens);

    // Call ParseBasicExpr and get the result
    ASTNode *result = parser.Parse();

    // Assert the results
    if (result != NULL && result.GetNodeType() == TYPE_PATTERN_NODE)
    {
        PatternNode *patternNode = (PatternNode *)result;
        if (patternNode.GetPattern() == "I" && patternNode.GetDirection() == "f" && patternNode.GetQuantifier() == "+")
        {
            Print("[PASS] Test Passed: Correct pattern, direction, and quantifier");
        }
        else
        {
            Print("[FAIL] Test Failed: Incorrect pattern, direction, or quantifier");
        }
    }
    else
    {
        Print("[FAIL] Test Failed: Incorrect node type");
    }

    // Cleanup
    delete result;
    for (int i = 0; i < mockTokens.Total(); i++)
    {
        delete mockTokens.At(i);
    }
    delete mockTokens;
}

void OnStart()
{
    TestParseBasicExpr();
}
