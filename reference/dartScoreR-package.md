# dartScoreR: A Package for X01 Darts Game Scoring

The dartScoreR package provides an R6 class-based system for playing and
analyzing X01 darts games (301, 501, etc.). It handles score tracking,
turn management, bust detection, and provides comprehensive game
statistics.

## Main Class

- [`darts`](https://jtalboys.github.io/dartScoreR/reference/darts.md):

  The primary R6 class for managing a darts game

## Utility Functions

- [`parse_darts`](https://jtalboys.github.io/dartScoreR/reference/parse_darts.md):

  Parse dart notation strings to scores

- [`is_valid_dart_score`](https://jtalboys.github.io/dartScoreR/reference/is_valid_dart_score.md):

  Validate dart scores

- [`get_valid_dart_scores`](https://jtalboys.github.io/dartScoreR/reference/get_valid_dart_scores.md):

  Get all valid single-dart scores

- [`get_checkout_doubles`](https://jtalboys.github.io/dartScoreR/reference/get_checkout_doubles.md):

  Get all valid checkout doubles

- [`max_turn_score`](https://jtalboys.github.io/dartScoreR/reference/max_turn_score.md):

  Get maximum possible turn score

## Author

**Maintainer**: Jack Talboys <jtalboys1@virginmedia.com>
