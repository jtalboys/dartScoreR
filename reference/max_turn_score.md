# Calculate Maximum Possible Turn Score

Returns the maximum score achievable in a single turn (180 with 3
darts).

## Usage

``` r
max_turn_score(num_darts = 3L)
```

## Arguments

- num_darts:

  Integer. Number of darts (1-3). Default is 3.

## Value

Integer maximum score.

## Examples

``` r
max_turn_score()      # 180
#> [1] 180
max_turn_score(1)     # 60
#> [1] 60
max_turn_score(2)     # 120
#> [1] 120
```
