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

- **Forward Consolidation `C+f`:** Equivalent to a series of bars in any direction or forward imbalances during a forward direction, denoted as `(Bf|Br|If)+`.
- **Reverse Consolidation `C+r`:** Equivalent to a series of bars in any direction or reverse imbalances during a reverse direction, denoted as `(Bf|Br|Ir)+`.
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

- **`(I+f|P+r)>C*f>I+r>C+f>I+r`:** This pattern represents a sequence where the first stage is either one or more forward imbalances `I+f` or a reverse pinbar `P+r`, followed by any number of forward consolidations `C*f`, then one or more reverse imbalances `I+r`, followed by one or more forward consolidations `C+f`, and finally, one or more reverse imbalances `I+r` again.

## API

### `TradeQL.match`

Matches a TradeQL query against a sequence of bars given a trend.

#### Parameters

- `query` (`string`): The TradeQL query string.
- `bars` (`srray` of `Bar`): An array of `Bar` objects, each with `open`, `close`, `high`, `low` properties of type `double`.
- `trend` (`Trend`): The market trend, either bullish or bearish.

#### Returns

- An array where each element is a `Match` object. The structure of each `Match` object is:
  - `startPos` (`integer`): The starting position of the match or group in the sequence.
  - `endPos` (`integer`): The ending position of the match or group in the sequence.

#### Example Usage

```c
query = "(I+f|P+r)>C*f>I+r>C+f>I+r";
bars = [{ open: ..., close: ..., high: ..., low: ... }, ...];
trend = "bullish"; // or "bearish"

matches = TradeQL.match(query, bars, trend);
print(matches[0]); // { startPos: ..., endPos: ... } - full match
print(matches[1]); // { startPos: ..., endPos: ... } - first captured group, if present
print(matches[2]); // { startPos: ..., endPos: ... } - second captured group, if present
```

#### Notes:

- The first element of the matches array represents the full match of the query.
- Subsequent elements represent captured groups within the query, if present.
- This structure allows users access the start and end positions of both the full match and any sub-patterns captured by groups.

### `TradeQL.Imbalance`

Allows users to define custom logic for detecting imbalances in a bar.

#### Parameters

- `index` (`integer`): The index of the bar in the sequence to inspect for imbalance.

#### Returns

- (`boolean`): Returns `true` if the bar at the specified index has price imbalance, otherwise `false`.

#### Example Usage

```c
TradeQL.Imbalance = function(index) {
    bar = this.getBar(index);
    hasImbalance = false;
    /* Define custom logic to determine an imbalance */
    return hasImbalance;
};
```

### `TradeQL.Pinbar`

This function enables users to define custom logic for identifying pinbars within a bar sequence.

#### Parameters

- `index` (`integer`): The index of the bar in the sequence to be checked for being a pinbar.

#### Returns

- (`Array`): Returns an array with two elements:
  - `isPinbar` (`boolean`): `true` if the bar at the specified index is identified as a pinbar, otherwise `false`.
  - `withDirection` (`boolean`): `true` if the pinbar is aligned with the current trend direction, otherwise `false`.

#### Example Usage

```c
TradeQL.Pinbar = function(index) {
    bar = this.getBar(index);
    isPinbar = false;
    withDirection = false;
    /* Define custom logic to identify a pinbar */
    return [isPinbar, withDirection];
};
```

#### Notes

- **Pinbar Characteristics:** A pinbar is characterized by a very long wick on one side, a very small body, and a very small wick on the opposite side. The direction of the long wick relative to the trend is crucial for analysis.
- **Directional Significance:**
  - In a bullish trend, a pinbar with the long wick on the high side (upper wick) is considered "against the trend" or a "rejection pinbar". It suggests rejection of higher prices or a potential bearish reversal.
  - Conversely, in a bearish trend, a pinbar with the long wick on the low side (lower wick) would be "against the trend" and might indicate a rejection of lower prices or a potential bullish reversal.
- **Implementation in TradeQL.Pinbar:**
  - When implementing the TradeQL.Pinbar function, users should consider the trend context to determine if the pinbar is 'with direction' or 'against direction'.
  - The `withDirection` boolean should reflect whether the pinbar aligns with or opposes the current trend, based on the orientation of its long wick.
- **Example:** A pinbar that goes withDirection is one where the orientation of its long wick aligns with the current market trend, suggesting a continuation of that trend. For example, given a bullish trend, a pinbar `withDirection=true` is a pinbar where the long wick is on the Low side.

### Utility Functions

TradeQL provides a few key utility functions within its framework to facilitate the analysis of trading bar sequences.

#### `this.getBar(index)`

- **Functionality:** Provides access to a specific `Bar` object in the sequence, identified by its index.
- **Parameter**
  - `index` (`integer`): The index of the bar in the sequence.
- **Return Type:** `Bar` object.
- **Usage:** Useful for targeted analysis of a single bar and their properties like open, close, high, and low values.

#### `this.getTrend`

- **Functionality:** Retrieves the current market trend being used in the TradeQL analysis.
- **Return Type:** `Trend`, which is a string value, typically either 'bullish' or 'bearish'.
- **Usage:** This function is used to obtain the trend context in which the TradeQL analysis is being performed.
