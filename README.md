# TradeQL `v0.1.0`
> An intuitive and concise query language for precisely defining and analyzing candlestick chart patterns in trading.

## Introduction

Here we present a Domain-Specific Language (DSL) designed specifically for the concise and precise description of trading patterns observed in candlestick charts. This DSL enables traders and analysts to articulate complex trading scenarios with a level of clarity and brevity akin to regular expressions used in programming. By standardizing the way these patterns are described, this language aims to facilitate clearer communication and analysis within the trading community.

## Basic Elements

### Patterns

- **Imbalance `I`:** Represents a bar with a price imbalance.
- **Bar `B`:** A standard bar without specific characteristics.
- **Pin `P`:** A bar with a long wick, indicative of a pinbar or doji.

### Direction
TradeQL is designed to describe the pattern's direction relative to an already established or known trend, without inherently specifying the trend's bullish or bearish nature.
- **Forward `f`:** Indicates a pattern moving _along_ with the known trend, regardless of whether the trend is bullish or bearish.
- **Reverse `r`:** Indicates a pattern moving _against_ the known trend, again without specifying if the trend is bullish or bearish.

### Quantifiers
Quantifiers follow the direction and specify the quantity:

- **0 or more `*`:** An unspecified number of occurrences, including none.
- **1 or more `+`:** At least one occurrence.
- **Specific amount `{n}`:** Exactly 'n' occurrences, where 'n' is a number.

### Meta-Patterns
- **Forward Consolidation `C+f`:** Equivalent to a series of bars or imbalances in any trend during a forward direction, denoted as `(Bf|Br|If)+`.
- **Reverse Consolidation `C+r`:** Equivalent to a series of bars or imbalances in any trend during a reverse direction, denoted as `(Bf|Br|Ir)+`.
- **Neutral Consolidation `C+`:** A series of bars in either forward or reverse directions, without imbalances, denoted as `(Bf|Br)+`.

### Additional Syntax
- **Alternation `|`:** Used to denote a choice between different patterns or directions.
- **Grouping `()`:** Used to group patterns and directions together for combined interpretation.
- **Sequence Indicator `>`:** Denotes the sequence in which patterns should occur.

### Syntax Rules
- Patterns can be combined with directions and then quantifiers.
- Meta-patterns provide shorthand notation for common complex sequences.
- Alternation and grouping allow for the description of complex and varied patterns.
- The sequence indicator is essential for defining the order of occurrence of patterns.

## Examples

### Simple Patterns
- **`Bf+`:** A series of forward bars
- **`P{2}r`:** At least two reverse pinbars

### Complex Pattern
- **`(I+f|P+r)>C*f>I+r>C+f>I+r`:**` This pattern represents a sequence where the first stage is either one or more forward imbalances (I+f) or a reverse pinbar (P+r), followed by any number of forward consolidations (C*f), then one or more reverse imbalances (I+r), followed by one or more forward consolidations (C+f), and finally, one or more reverse imbalances (I+r) again.

This DSL, with its simple yet powerful syntax, offers a versatile tool for traders and analysts in the financial sector, aiding in the efficient and accurate representation of candlestick chart patterns.