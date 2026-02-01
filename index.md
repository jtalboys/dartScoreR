# dartScoreR

`dartScoreR` is an R package for playing and analyzing X01 darts games
(301, 501, etc.). It provides an R6 class-based system for game
management, score tracking, bust detection, and comprehensive game
statistics.

## Features

- **R6 Game Class**: Object-oriented design with `darts` class for easy
  game management
- **Flexible Score Input**: Support for dart notation (“T20”, “D16”,
  “BULL”) or numeric scores
- **Double-Out Rules**: Configurable double-out requirement with
  automatic bust detection
- **Game Statistics**: Three-dart average, highest turn, bust count, and
  more
- **Turn History**: Full turn-by-turn tracking with undo capability
- **Method Chaining**: Fluent interface for concise game scripting

## Installation

To install the development version of `dartScoreR`:

``` r
# Install devtools if needed
install.packages("devtools")

# Install from local directory
devtools::install_local("path/to/dartScoreR")

# Or install from GitHub (if published)
# devtools::install_github("username/dartScoreR")
```

## Quick Start

``` r
library(dartScoreR)

# Create a new 501 game
game <- darts$new(starting_score = 501, player_name = "Alice")

# Throw darts using notation
game$throw(c("T20", "T20", "T20"))  # 180!
game$throw(c("T20", "T19", "T18"))  # 177

# Check current score
game$current_score
#> [1] 144

# View game summary
game$summary()
#> $player_name
#> [1] "Alice"
#> $current_score
#> [1] 144
#> $three_dart_average
#> [1] 178.5
#> ...

# Get turn history as data frame
game$get_turns()
```

## Dart Notation

The package supports flexible dart notation:

| Notation            | Description            | Points |
|---------------------|------------------------|--------|
| `S1`-`S20`          | Single                 | 1-20   |
| `D1`-`D20`          | Double                 | 2-40   |
| `T1`-`T20`          | Triple                 | 3-60   |
| `25`, `SB`          | Outer Bull             | 25     |
| `BULL`, `D25`, `50` | Bullseye (Double)      | 50     |
| `0`, `M`, `MISS`    | Miss                   | 0      |
| Plain numbers       | Interpreted as singles | 1-20   |

## Game Rules

- **Bust Detection**: Automatically detects when a player goes below 0
  or to 1 (with double-out)
- **Double-Out**: Configurable via `double_out = TRUE/FALSE` parameter
- **Turn Tracking**: Each turn can have 1-3 darts

``` r
# Game with double-out (default)
game <- darts$new(starting_score = 40, double_out = TRUE)
game$throw(c("D20"))  # Finishes the game!
game$is_finished()
#> [1] TRUE

# Game without double-out requirement
game <- darts$new(starting_score = 40, double_out = FALSE)
game$throw(c("S20", "S20"))  # Also finishes
```

## Utility Functions

``` r
# Parse dart notation
parse_darts(c("T20", "D16", "BULL"))
#> $scores
#> [1] 60 32 50
#> $is_double
#> [1] FALSE TRUE TRUE

# Get all valid checkout doubles
get_checkout_doubles()
#> [1]  2  4  6  8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 50

# Validate a dart score
is_valid_dart_score(60)  # TRUE (T20)
is_valid_dart_score(59)  # FALSE (not achievable)
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull
requests.

## License

This package is licensed under the MIT License. See the LICENSE file for
more details.
