// Forward declarations
class TradeQL;
class Parser;
class TqlBar;
class TqlMatch;
class Lexer;
class Token;
class ASTNode;
class PatternNode;
class Parser;

// TradeQL
typedef bool (*ImbalanceFunction)(TradeQL &tradeQL, int index);
typedef bool (*PinbarFunction)(TradeQL &tradeQL, int index);

// Parser
typedef ASTNode *(*ParseBasicExprFunction)(Parser &parser);
