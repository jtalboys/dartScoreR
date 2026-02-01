# Validate Dart Score

Checks if a dart score is valid (achievable with a single dart).

## Usage

``` r
is_valid_dart_score(score)
```

## Arguments

- score:

  Integer. The score to validate.

## Value

Logical indicating if the score is valid.

## Examples

``` r
is_valid_dart_score(60)   # TRUE (T20)
#> [1] TRUE
is_valid_dart_score(59)   # FALSE (not achievable)
#> [1] FALSE
is_valid_dart_score(50)   # TRUE (bullseye)
#> [1] TRUE
```
