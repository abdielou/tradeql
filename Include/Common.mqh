// Forward declarations
class TradeQL;
class Parser;
class Bar;
class Match;
class Lexer;
class Token;
class ASTNode;
class PatternNode;
class Parser;

// TradeQL
typedef bool (*ImbalanceFunction)(TradeQL &tradeQL, int index);
typedef bool (*PinbarFunction)(TradeQL &tradeQL, int index);
