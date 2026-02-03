test_that("parse_darts handles triple notation", {
  result <- parse_darts(c("T20", "T19", "T18"))

  expect_equal(result$scores, c(60L, 57L, 54L))
  expect_equal(result$is_double, c(FALSE, FALSE, FALSE))
})

test_that("parse_darts handles double notation", {
  result <- parse_darts(c("D20", "D16", "D10"))

  expect_equal(result$scores, c(40L, 32L, 20L))
  expect_equal(result$is_double, c(TRUE, TRUE, TRUE))
})

test_that("parse_darts handles single notation", {
  result <- parse_darts(c("S20", "S5", "S1"))

  expect_equal(result$scores, c(20L, 5L, 1L))
  expect_equal(result$is_double, c(FALSE, FALSE, FALSE))
})

test_that("parse_darts handles bullseye variants", {
  result <- parse_darts(c("BULL"))
  expect_equal(result$scores, 50L)
  expect_true(result$is_double)

  result <- parse_darts(c("D25"))
  expect_equal(result$scores, 50L)
  expect_true(result$is_double)

  result <- parse_darts(c("25"))
  expect_equal(result$scores, 25L)
  expect_false(result$is_double)

  result <- parse_darts(c("SB"))
  expect_equal(result$scores, 25L)
  expect_false(result$is_double)
})

test_that("parse_darts handles miss notation", {
  result <- parse_darts(c("0"))
  expect_equal(result$scores, 0L)

  result <- parse_darts(c("M"))
  expect_equal(result$scores, 0L)

  result <- parse_darts(c("MISS"))
  expect_equal(result$scores, 0L)
})

test_that("parse_darts handles plain numbers", {
  result <- parse_darts(c("20", "5", "1"))

  expect_equal(result$scores, c(20L, 5L, 1L))
  expect_equal(result$is_double, c(FALSE, FALSE, FALSE))
})

test_that("parse_darts handles numeric input", {
  result <- parse_darts(c(60, 57, 54))

  expect_equal(result$scores, c(60L, 57L, 54L))
  expect_equal(result$is_double, c(FALSE, FALSE, FALSE))
})

test_that("parse_darts handles mixed case", {
  result <- parse_darts(c("t20", "D16", "s5"))

  expect_equal(result$scores, c(60L, 32L, 5L))
})

test_that("parse_darts errors on invalid notation", {
  expect_error(parse_darts(c("X20")))
  expect_error(parse_darts(c("T25")))  # No triple 25
  expect_error(parse_darts(c("D21")))  # No 21 segment
})

test_that("parse_darts errors on more than 3 darts", {
  expect_error(parse_darts(c("T20", "T20", "T20", "T20")), "Maximum 3 darts")
})

test_that("parse_darts handles empty input", {
  result <- parse_darts(character(0))

  expect_equal(result$scores, integer(0))
  expect_equal(result$is_double, logical(0))
})

test_that("is_valid_dart_score validates correctly", {
  expect_true(is_valid_dart_score(60))   # T20
  expect_true(is_valid_dart_score(50))   # Bull
  expect_true(is_valid_dart_score(25))   # Outer bull
  expect_true(is_valid_dart_score(20))   # S20 or D10
  expect_true(is_valid_dart_score(0))    # Miss

  expect_false(is_valid_dart_score(59))  # Not achievable
  expect_false(is_valid_dart_score(61))  # Above max
  expect_false(is_valid_dart_score(-1))  # Negative
})

test_that("get_valid_dart_scores returns expected values", {
  scores <- get_valid_dart_scores()

  expect_true(0 %in% scores)
  expect_true(60 %in% scores)
  expect_true(50 %in% scores)
  expect_true(25 %in% scores)
  expect_false(59 %in% scores)
})

test_that("get_checkout_doubles returns all valid doubles", {
  doubles <- get_checkout_doubles()

  expect_equal(length(doubles), 21)  # D1-D20 plus Bull
  expect_true(2 %in% doubles)   # D1
  expect_true(40 %in% doubles)  # D20
  expect_true(50 %in% doubles)  # Bull
  expect_false(1 %in% doubles)  # Not a double
})

test_that("max_turn_score returns correct values", {
  expect_equal(max_turn_score(), 180L)
  expect_equal(max_turn_score(1), 60L)
  expect_equal(max_turn_score(2), 120L)
  expect_equal(max_turn_score(3), 180L)
})

test_that("max_turn_score errors on invalid input", {
  expect_error(max_turn_score(0))
  expect_error(max_turn_score(4))
})

test_that("parse_darts handles whitespace in input", {
  result <- parse_darts(c(" T20 ", "  D16", "S5  "))
  
  expect_equal(result$scores, c(60L, 32L, 5L))
  expect_equal(result$is_double, c(FALSE, TRUE, FALSE))
})

test_that("get_valid_dart_scores includes all expected scores", {
  scores <- get_valid_dart_scores()
  
  # Check some key scores exist
  expect_true(all(c(0, 1, 20, 25, 40, 50, 60) %in% scores))
  
  # Check some invalid scores don't exist
  expect_false(any(c(23, 59, 61, -1) %in% scores))
  
  # Verify sorted
  expect_equal(scores, sort(scores))
})

test_that("parse_single_dart handles edge cases", {
  # Test case insensitivity
  expect_equal(parse_single_dart("t20"), parse_single_dart("T20"))
  expect_equal(parse_single_dart("d16"), parse_single_dart("D16"))
  
  # Test various bullseye notations
  expect_equal(parse_single_dart("BULL")$score, 50L)
  expect_equal(parse_single_dart("DB")$score, 50L)
  expect_equal(parse_single_dart("DBULL")$score, 50L)
  
  # Test miss variations
  expect_equal(parse_single_dart("M")$score, 0L)
  expect_equal(parse_single_dart("MISS")$score, 0L)
  expect_equal(parse_single_dart("")$score, 0L)
})
