#include <Arrays\ArrayObj.mqh>
#include "../Include/tradeql/parse/Parser.mqh"

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
        if (
            patternNode.GetPattern() == PATTERN_IMBALANCE &&
            patternNode.GetDirection() == DIRECTION_FORWARD &&
            patternNode.GetQuantifier() == QUANTIFIER_ONE_OR_MORE)
        {
            Print("[PASS] Test Passed: Correct pattern, direction, and quantifier for BasicExpr");
        }
        else
        {
            Print("[FAIL] Test Failed: Incorrect pattern, direction, or quantifier for BasicExpr");
        }
    }
    else
    {
        Print("[FAIL] Test Failed: Incorrect node type for BasicExpr");
    }

    // Cleanup
    delete result;
    for (int i = 0; i < mockTokens.Total(); i++)
    {
        delete mockTokens.At(i);
    }
    delete mockTokens;
}

void TestParseAltExpr()
{
    // Create a mock token list for an alternation expression
    CArrayObj *mockTokens = new CArrayObj();
    mockTokens.Add(new Token(TOKEN_IMBALANCE, "I"));   // Pattern
    mockTokens.Add(new Token(TOKEN_ALTERNATION, "|")); // Alternation
    mockTokens.Add(new Token(TOKEN_BAR, "B"));         // Pattern
    mockTokens.Add(new Token(TOKEN_FORWARD, "f"));     // Direction
    mockTokens.Add(new Token(TOKEN_ONE_OR_MORE, "+")); // Quantifier

    // Instantiate the parser with the mock token list
    Parser parser(mockTokens);

    // Call ParseAltExpr and get the result
    ASTNode *result = parser.Parse();

    // Assert the results
    if (result != NULL && result.GetNodeType() == TYPE_ALT_EXPR_NODE)
    {
        AltExprNode *altExprNode = (AltExprNode *)result;
        if (altExprNode.GetExpressions().Total() == 2)
        {
            Print("[PASS] Test Passed: Correct number of expressions in AltExpr");
        }
        else
        {
            Print("[FAIL] Test Failed: Incorrect number of expressions in AltExpr");
        }
    }
    else
    {
        Print("[FAIL] Test Failed: Incorrect node type for AltExpr");
    }

    // Cleanup
    delete result;
    for (int i = 0; i < mockTokens.Total(); i++)
    {
        delete mockTokens.At(i);
    }
    delete mockTokens;
}

void TestParseGroup()
{
    // Create a mock token list for a group expression
    CArrayObj *mockTokens = new CArrayObj();
    mockTokens.Add(new Token(TOKEN_GROUP_OPEN, "("));  // Group start
    mockTokens.Add(new Token(TOKEN_IMBALANCE, "I"));   // Pattern
    mockTokens.Add(new Token(TOKEN_ALTERNATION, "|")); // Alternation
    mockTokens.Add(new Token(TOKEN_BAR, "B"));         // Pattern
    mockTokens.Add(new Token(TOKEN_GROUP_CLOSE, ")")); // Group end
    mockTokens.Add(new Token(TOKEN_ONE_OR_MORE, "+")); // Quantifier

    // Instantiate the parser with the mock token list
    Parser parser(mockTokens);

    // Call ParseGroup and get the result
    ASTNode *result = parser.Parse();

    // Assert the results
    if (result != NULL && result.GetNodeType() == TYPE_GROUP_NODE)
    {
        GroupNode *groupNode = (GroupNode *)result;
        if (
            groupNode.GetQuantifier() == QUANTIFIER_ONE_OR_MORE &&
            (groupNode.GetInnerExpression().GetNodeType() == TYPE_PATTERN_NODE ||
             groupNode.GetInnerExpression().GetNodeType() == TYPE_ALT_EXPR_NODE))
        {
            Print("[PASS] Test Passed: Correct structure and quantifier for Group");
        }
        else
        {
            Print("[FAIL] Test Failed: Incorrect structure or quantifier for Group");
        }
    }
    else
    {
        Print("[FAIL] Test Failed: Incorrect node type for Group");
    }

    // Cleanup
    delete result;
    for (int i = 0; i < mockTokens.Total(); i++)
    {
        delete mockTokens.At(i);
    }
    delete mockTokens;
}

void TestParseExpression()
{
    // Create a mock token list for an AltExpr (Expression)
    CArrayObj *altExprMockTokens = new CArrayObj();
    altExprMockTokens.Add(new Token(TOKEN_IMBALANCE, "I"));   // Pattern
    altExprMockTokens.Add(new Token(TOKEN_ALTERNATION, "|")); // Alternation
    altExprMockTokens.Add(new Token(TOKEN_BAR, "B"));         // Pattern
    altExprMockTokens.Add(new Token(TOKEN_FORWARD, "f"));     // Direction
    altExprMockTokens.Add(new Token(TOKEN_ONE_OR_MORE, "+")); // Quantifier

    // And also for Group (Also Expression)
    CArrayObj *groupMockTokens = new CArrayObj();
    groupMockTokens.Add(new Token(TOKEN_GROUP_OPEN, "("));  // Group start
    groupMockTokens.Add(new Token(TOKEN_IMBALANCE, "I"));   // Pattern
    groupMockTokens.Add(new Token(TOKEN_ALTERNATION, "|")); // Alternation
    groupMockTokens.Add(new Token(TOKEN_BAR, "B"));         // Pattern
    groupMockTokens.Add(new Token(TOKEN_GROUP_CLOSE, ")")); // Group end
    groupMockTokens.Add(new Token(TOKEN_ONE_OR_MORE, "+")); // Quantifier

    // Instantiate the parser with the mock token list
    Parser altExprParser(altExprMockTokens);
    Parser groupParser(groupMockTokens);

    // Call ParseExpression and get the result
    ASTNode *altExprResult = altExprParser.Parse();
    ASTNode *groupResult = groupParser.Parse();

    // Assert the results for AltExpr
    if (altExprResult != NULL && altExprResult.GetNodeType() == TYPE_ALT_EXPR_NODE)
    {
        AltExprNode *altExprNode = (AltExprNode *)altExprResult;
        if (altExprNode.GetExpressions().Total() == 2)
        {
            Print("[PASS] Test Passed: Correct number of expressions in Expression (AltExpr)");
        }
        else
        {
            Print("[FAIL] Test Failed: Incorrect number of expressions in Expression (AltExpr)");
        }
    }
    else
    {
        Print("[FAIL] Test Failed: Incorrect node type for Expression (AltExpr)");
    }

    // Assert the results for Group
    if (groupResult != NULL && groupResult.GetNodeType() == TYPE_GROUP_NODE)
    {
        GroupNode *groupNode = (GroupNode *)groupResult;
        if (groupNode.GetQuantifier() == QUANTIFIER_ONE_OR_MORE && groupNode.GetInnerExpression().GetNodeType() == TYPE_ALT_EXPR_NODE)
        {
            Print("[PASS] Test Passed: Correct structure and quantifier for Expression (Group)");
        }
        else
        {
            Print("[FAIL] Test Failed: Incorrect structure or quantifier for Expression (Group)");
        }
    }
    else
    {
        Print("[FAIL] Test Failed: Incorrect node type for Expression (Group)");
    }

    // Cleanup
    delete altExprResult;
    delete groupResult;
    for (int i = 0; i < altExprMockTokens.Total(); i++)
    {
        delete altExprMockTokens.At(i);
    }
    for (int i = 0; i < groupMockTokens.Total(); i++)
    {
        delete groupMockTokens.At(i);
    }
    delete altExprMockTokens;
    delete groupMockTokens;
}

void TestParseSequenceExpr()
{
    // Create a mock token list for a sequence expression
    CArrayObj *mockTokens = new CArrayObj();
    mockTokens.Add(new Token(TOKEN_IMBALANCE, "I"));   // First Expression
    mockTokens.Add(new Token(TOKEN_SEQUENCE, ">"));    // Sequence operator
    mockTokens.Add(new Token(TOKEN_GROUP_OPEN, "("));  // Group start
    mockTokens.Add(new Token(TOKEN_BAR, "B"));         // Pattern in Group
    mockTokens.Add(new Token(TOKEN_GROUP_CLOSE, ")")); // Group end
    mockTokens.Add(new Token(TOKEN_ONE_OR_MORE, "+")); // Quantifier in Group

    // Instantiate the parser with the mock token list
    Parser parser(mockTokens);

    // Call ParseSequenceExpr and get the result
    ASTNode *result = parser.Parse();

    // Assert the results
    if (result != NULL && result.GetNodeType() == TYPE_SEQUENCE_EXPR_NODE)
    {
        SequenceExprNode *sequenceExprNode = (SequenceExprNode *)result;
        if (sequenceExprNode.GetExpressions().Total() == 2)
        {
            Print("[PASS] Test Passed: Correct number of expressions in SequenceExpr");
        }
        else
        {
            Print("[FAIL] Test Failed: Incorrect number of expressions in SequenceExpr");
        }
    }
    else
    {
        Print("[FAIL] Test Failed: Incorrect node type for SequenceExpr");
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
    TestParseAltExpr();
    TestParseGroup();
    TestParseSequenceExpr();
}
