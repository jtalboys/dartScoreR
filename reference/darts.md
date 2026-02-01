# X01 Darts Game

An R6 class representing an X01 darts game (e.g., 301, 501, 701). Tracks
scores, turns, and provides game statistics.

## Details

The game follows standard X01 rules:

- Players start with a specified score (e.g., 501)

- Each turn consists of up to 3 darts

- Players subtract their score from the starting total

- Game ends when a player reaches exactly 0 with a double

- "Busting" (going below 0 or to 1) resets the turn

## Active bindings

- `current_score`:

  The current remaining score.

- `starting_score`:

  The starting score for the game.

- `player_name`:

  The player's name.

- `turns_played`:

  The number of turns played.

## Methods

### Public methods

- [`darts$new()`](#method-darts-new)

- [`darts$throw()`](#method-darts-throw)

- [`darts$undo()`](#method-darts-undo)

- [`darts$is_finished()`](#method-darts-is_finished)

- [`darts$summary()`](#method-darts-summary)

- [`darts$get_turns()`](#method-darts-get_turns)

- [`darts$print()`](#method-darts-print)

- [`darts$clone()`](#method-darts-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new X01 game

#### Usage

    darts$new(starting_score = 501L, player_name = "Player 1", double_out = TRUE)

#### Arguments

- `starting_score`:

  Integer. The starting score (e.g., 301, 501). Default is 501.

- `player_name`:

  Character. The player's name. Default is "Player 1".

- `double_out`:

  Logical. Whether the game requires a double to finish. Default is
  TRUE.

#### Returns

A new `darts` object.

------------------------------------------------------------------------

### Method `throw()`

Record a turn (up to 3 darts)

#### Usage

    darts$throw(darts)

#### Arguments

- `darts`:

  Character vector of dart notations (e.g., c("T20", "T20", "T20")) or a
  numeric vector of scores. Maximum 3 darts per turn.

#### Returns

Invisible self for method chaining.

------------------------------------------------------------------------

### Method `undo()`

Undo the last turn

#### Usage

    darts$undo()

#### Returns

Invisible self for method chaining.

------------------------------------------------------------------------

### Method `is_finished()`

Check if the game is finished

#### Usage

    darts$is_finished()

#### Returns

Logical indicating if the game is complete.

------------------------------------------------------------------------

### Method [`summary()`](https://rdrr.io/r/base/summary.html)

Get game summary statistics

#### Usage

    darts$summary()

#### Returns

A list containing game statistics.

------------------------------------------------------------------------

### Method `get_turns()`

Get all turns as a data frame

#### Usage

    darts$get_turns()

#### Returns

A data frame with turn-by-turn information.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print method for the game

#### Usage

    darts$print(...)

#### Arguments

- `...`:

  Additional arguments (unused).

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    darts$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
