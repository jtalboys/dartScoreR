#' Parse Dart Notation
#'
#' Parses dart notation strings (e.g., "T20", "D16", "S5", "BULL", "25")
#' into their numeric scores and identifies doubles.
#'
#' @param darts A character vector of dart notations or a numeric vector of
#'   scores.
#'   Valid string notations include:
#'   - "S1" to "S20": Single (1-20 points)
#'   - "D1" to "D20": Double (2-40 points, even numbers only)
#'   - "T1" to "T20": Triple (3-60 points)
#'   - "BULL" or "D25" or "DB": Double bull (50 points, counts as double)
#'   - "25" or "S25" or "SB": Single bull (25 points)
#'   - "0" or "M" or "MISS": Miss (0 points)
#'   - Numeric values are also accepted directly
#'
#' @return A list with two elements:
#'   \item{scores}{Integer vector of point values}
#'   \item{is_double}{Logical vector indicating if each dart was a double}
#'
#' @examples
#' parse_darts(c("T20", "T20", "T20"))
#' parse_darts(c("T20", "19", "D16"))
#' parse_darts(c("BULL", "25", "D20"))
#'
#' @export
parse_darts <- function(darts) {
  if (length(darts) == 0) {
    return(list(scores = integer(0), is_double = logical(0)))
  }

  if (length(darts) > 3) {
    stop("Maximum 3 darts per turn.")
  }

  # If numeric, convert to integer and assume no doubles
  if (is.numeric(darts)) {
    scores <- as.integer(darts)
    is_double <- rep(FALSE, length(scores))
    return(list(scores = scores, is_double = is_double))
  }

  # Parse string notation
  scores <- integer(length(darts))
  is_double <- logical(length(darts))

  for (i in seq_along(darts)) {
    parsed <- parse_single_dart(darts[i])
    scores[i] <- parsed$score
    is_double[i] <- parsed$is_double
  }

  list(scores = scores, is_double = is_double)
}


#' Parse a Single Dart Notation
#'
#' Internal function to parse a single dart notation string.
#'
#' @param dart A single dart notation string.
#'
#' @return A list with score (integer) and is_double (logical).
#'
#' @keywords internal
parse_single_dart <- function(dart) {
  dart <- toupper(trimws(dart))

  # Handle miss
  if (dart %in% c("0", "M", "MISS", "")) {
    return(list(score = 0L, is_double = FALSE))
  }

  # Handle bullseye variants
  if (dart %in% c("BULL", "DB", "D25", "DBULL", "50")) {
    return(list(score = 50L, is_double = TRUE))
  }

  if (dart %in% c("25", "SB", "S25", "SBULL")) {
    return(list(score = 25L, is_double = FALSE))
  }

  # Handle standard notation (T20, D16, S5, etc.)
  if (grepl("^[TDS][0-9]{1,2}$", dart)) {
    prefix <- substr(dart, 1, 1)
    number <- as.integer(substr(dart, 2, nchar(dart)))

    if (number < 1 || number > 20) {
      stop(sprintf("Invalid dart segment: %s. Must be 1-20.", dart))
    }

    multiplier <- switch(prefix,
      "S" = 1L,
      "D" = 2L,
      "T" = 3L
    )

    return(list(
      score = as.integer(number * multiplier),
      is_double = (prefix == "D")
    ))
  }

  # Handle plain numbers (interpreted as singles)
  if (grepl("^[0-9]{1,2}$", dart)) {
    number <- as.integer(dart)
    if (number >= 1 && number <= 20) {
      return(list(score = number, is_double = FALSE))
    } else if (number == 25) {
      return(list(score = 25L, is_double = FALSE))
    } else if (number == 50) {
      return(list(score = 50L, is_double = TRUE))
    } else {
      stop(sprintf("Invalid dart value: %s", dart))
    }
  }

  stop(sprintf("Unrecognized dart notation: '%s'", dart))
}


#' Validate Dart Score
#'
#' Checks if a dart score is valid (achievable with a single dart).
#'
#' @param score Integer. The score to validate.
#'
#' @return Logical indicating if the score is valid.
#'
#' @examples
#' is_valid_dart_score(60)   # TRUE (T20)
#' is_valid_dart_score(59)   # FALSE (not achievable)
#' is_valid_dart_score(50)   # TRUE (bullseye)
#'
#' @export
is_valid_dart_score <- function(score) {
  valid_scores <- get_valid_dart_scores()
  score %in% valid_scores
}


#' Get All Valid Dart Scores
#'
#' Returns a vector of all possible scores achievable with a single dart.
#'
#' @return Integer vector of valid dart scores.
#'
#' @examples
#' get_valid_dart_scores()
#'
#' @export
get_valid_dart_scores <- function() {
  # Singles: 1-20
  singles <- 1L:20L
  
  # Doubles: 2, 4, 6, ..., 40
  doubles <- seq(2L, 40L, by = 2L)
  
  # Triples: 3, 6, 9, ..., 60
  triples <- seq(3L, 60L, by = 3L)
  
  # Bulls: 25 (outer), 50 (inner/double)
  bulls <- c(25L, 50L)
  
  # Miss
  miss <- 0L
  
  sort(unique(c(miss, singles, doubles, triples, bulls)))
}


#' Get All Possible Doubles
#'
#' Returns all valid checkout doubles (for double-out games).
#'
#' @return Integer vector of valid double scores.
#'
#' @examples
#' get_checkout_doubles()
#'
#' @export
get_checkout_doubles <- function() {
  # D1-D20 (2, 4, 6, ..., 40) plus D25/BULL (50)
  c(seq(2L, 40L, by = 2L), 50L)
}


#' Calculate Maximum Possible Turn Score
#'
#' Returns the maximum score achievable in a single turn (180 with 3 darts).
#'
#' @param num_darts Integer. Number of darts (1-3). Default is 3.
#'
#' @return Integer maximum score.
#'
#' @examples
#' max_turn_score()      # 180
#' max_turn_score(1)     # 60
#' max_turn_score(2)     # 120
#'
#' @export
max_turn_score <- function(num_darts = 3L) {
  stopifnot(num_darts >= 1 && num_darts <= 3)
  as.integer(60L * num_darts)
}
