test_that("X01Game initializes correctly", {
  game <- X01Game$new()

  expect_equal(game$starting_score, 501L)
  expect_equal(game$current_score, 501L)
  expect_equal(game$player_name, "Player 1")
  expect_equal(game$turns_played, 0L)
  expect_false(game$is_finished())
})

test_that("X01Game accepts custom starting score", {
  game <- X01Game$new(starting_score = 301)

  expect_equal(game$starting_score, 301L)
  expect_equal(game$current_score, 301L)
})

test_that("X01Game accepts custom player name", {
  game <- X01Game$new(player_name = "Test Player")

  expect_equal(game$player_name, "Test Player")
})

test_that("X01Game rejects invalid starting score", {
  expect_error(X01Game$new(starting_score = -100))
  expect_error(X01Game$new(starting_score = 0))
  expect_error(X01Game$new(starting_score = "abc"))
})

test_that("throw method reduces score correctly", {
  game <- X01Game$new(starting_score = 501)
  game$throw(c("T20", "T20", "T20"))

  expect_equal(game$current_score, 321L)
  expect_equal(game$turns_played, 1L)
})

test_that("throw method handles numeric input", {
  game <- X01Game$new(starting_score = 501)
  game$throw(c(60, 60, 60))

  expect_equal(game$current_score, 321L)
})

test_that("throw method detects bust when going below zero", {
  game <- X01Game$new(starting_score = 50)
  game$throw(c("T20", "T20", "T20"))  # 180 > 50, should bust


  expect_equal(game$current_score, 50L)  # Score unchanged due to bust

  summary <- game$summary()
  expect_equal(summary$bust_count, 1L)
})

test_that("throw method detects bust when reaching 1 with double out", {
  game <- X01Game$new(starting_score = 41, double_out = TRUE)
  game$throw(c("D20"))  # Would leave 1, which is a bust

  expect_equal(game$current_score, 41L)
})

test_that("throw method requires double to finish with double_out", {
  game <- X01Game$new(starting_score = 40, double_out = TRUE)
  game$throw(c("S20", "S20"))  # Would be 0 but not a double

  expect_equal(game$current_score, 40L)  # Bust
  expect_false(game$is_finished())
})

test_that("game finishes correctly on valid checkout", {
  game <- X01Game$new(starting_score = 40, double_out = TRUE)
  game$throw(c("D20"))

  expect_equal(game$current_score, 0L)
  expect_true(game$is_finished())
})

test_that("game finishes without double out requirement", {
  game <- X01Game$new(starting_score = 40, double_out = FALSE)
  game$throw(c("S20", "S20"))

  expect_equal(game$current_score, 0L)
  expect_true(game$is_finished())
})

test_that("cannot throw after game is finished", {
  game <- X01Game$new(starting_score = 40, double_out = TRUE)
  game$throw(c("D20"))

  expect_error(game$throw(c("T20")), "Game is already finished")
})

test_that("undo method restores previous state", {
  game <- X01Game$new(starting_score = 501)
  game$throw(c("T20", "T20", "T20"))
  game$undo()

  expect_equal(game$current_score, 501L)
  expect_equal(game$turns_played, 0L)
})

test_that("undo method errors when no turns to undo", {
  game <- X01Game$new()

  expect_error(game$undo(), "No turns to undo")
})

test_that("summary returns correct statistics", {
  game <- X01Game$new(starting_score = 501, player_name = "Test")
  game$throw(c("T20", "T20", "T20"))  # 180
  game$throw(c("T20", "T20", "T19"))  # 177

  summary <- game$summary()

  expect_equal(summary$player_name, "Test")
  expect_equal(summary$starting_score, 501L)
  expect_equal(summary$current_score, 144L)
  expect_false(summary$is_finished)
  expect_equal(summary$total_turns, 2L)
  expect_equal(summary$total_darts, 6L)
  expect_equal(summary$highest_turn, 180L)
})

test_that("get_turns returns correct data frame", {
  game <- X01Game$new(starting_score = 501)
  game$throw(c("T20", "T20", "T20"))
  game$throw(c("T19", "T19", "T19"))

  turns <- game$get_turns()

  expect_s3_class(turns, "data.frame")
  expect_equal(nrow(turns), 2)
  expect_equal(turns$turn_score, c(180L, 171L))
})

test_that("get_turns returns empty data frame for new game", {
  game <- X01Game$new()
  turns <- game$get_turns()

  expect_s3_class(turns, "data.frame")
  expect_equal(nrow(turns), 0)
})

test_that("method chaining works", {
  game <- X01Game$new(starting_score = 501)

  result <- game$throw(c("T20", "T20", "T20"))$throw(c("T20", "T20", "T20"))

  expect_equal(game$current_score, 141L)
})
