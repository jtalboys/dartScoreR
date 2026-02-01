# Parse Dart Notation

Parses dart notation strings (e.g., "T20", "D16", "S5", "BULL", "25")
into their numeric scores and identifies doubles.

## Usage

``` r
parse_darts(darts)
```

## Arguments

- darts:

  A character vector of dart notations or a numeric vector of scores.
  Valid string notations include:

  - "S1" to "S20": Single (1-20 points)

  - "D1" to "D20": Double (2-40 points, even numbers only)

  - "T1" to "T20": Triple (3-60 points)

  - "BULL" or "D25" or "DB": Double bull (50 points, counts as double)

  - "25" or "S25" or "SB": Single bull (25 points)

  - "0" or "M" or "MISS": Miss (0 points)

  - Numeric values are also accepted directly

## Value

A list with two elements:

- scores:

  Integer vector of point values

- is_double:

  Logical vector indicating if each dart was a double

## Examples

``` r
parse_darts(c("T20", "T20", "T20"))
#> $scores
#> [1] 60 60 60
#> 
#> $is_double
#> [1] FALSE FALSE FALSE
#> 
parse_darts(c("T20", "19", "D16"))
#> $scores
#> [1] 60 19 32
#> 
#> $is_double
#> [1] FALSE FALSE  TRUE
#> 
parse_darts(c("BULL", "25", "D20"))
#> $scores
#> [1] 50 25 40
#> 
#> $is_double
#> [1]  TRUE FALSE  TRUE
#> 
```
