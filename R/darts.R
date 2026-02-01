#' @title X01 Darts Game
#'
#' @description
#' An R6 class representing an X01 darts game (e.g., 301, 501, 701).
#' Tracks scores, turns, and provides game statistics.
#'
#' @details
#' The game follows standard X01 rules:
#' - Players start with a specified score (e.g., 501)
#' - Each turn consists of up to 3 darts
#' - Players subtract their score from the starting total
#' - Game ends when a player reaches exactly 0 with a double
#' - "Busting" (going below 0 or to 1) resets the turn
#'
#' @export
#' @importFrom R6 R6Class
darts <- R6::R6Class(

  classname = "darts",

  public = list(

    #' @description

    #' Create a new X01 game

    #' @param starting_score Integer. The starting score (e.g., 301, 501).
    #'   Default is 501.
    #' @param player_name Character. The player's name. Default is "Player 1".
    #' @param double_out Logical. Whether the game requires a double to finish.
    #'   Default is TRUE.
    #' @return A new `darts` object.
    initialize = function(starting_score = 501L,
                          player_name = "Player 1",
                          double_out = TRUE) {
      stopifnot(
        "starting_score must be a positive integer" =
          is.numeric(starting_score) &&
          starting_score > 0 &&
          starting_score %% 1 == 0,
        "player_name must be a character string" =
          is.character(player_name) && length(player_name) == 1,
        "double_out must be logical" =
          is.logical(double_out) && length(double_out) == 1
      )

      private$.starting_score <- as.integer(starting_score)
      private$.current_score <- as.integer(starting_score)
      private$.player_name <- player_name
      private$.double_out <- double_out
      private$.turns <- list()
      private$.finished <- FALSE
      private$.darts_thrown <- 0L

      invisible(self)
    },

    #' @description
    #' Record a turn (up to 3 darts)
    #' @param darts Character vector of dart notations
    #'   (e.g., c("T20", "T20", "T20"))
    #'   or a numeric vector of scores. Maximum 3 darts per turn.
    #' @return Invisible self for method chaining.
    throw = function(darts) {
      if (private$.finished) {
        stop("Game is already finished.")
      }


      # Parse darts to get scores and check for doubles
      parsed <- parse_darts(darts)
      turn_score <- sum(parsed$scores)
      num_darts <- length(parsed$scores)
      last_dart_double <- parsed$is_double[length(parsed$is_double)]

      # Check for bust
      potential_score <- private$.current_score - turn_score

      is_bust <- FALSE
      if (potential_score < 0) {
        is_bust <- TRUE
      } else if (potential_score == 1 && private$.double_out) {
        # Can't finish on 1 with double out
        is_bust <- TRUE
      } else if (
        potential_score == 0 &&
          private$.double_out &&
          !last_dart_double
      ) {
        # Must finish on a double
        is_bust <- TRUE
      }

      # Record the turn
      turn <- list(
        turn_number = length(private$.turns) + 1L,
        darts = darts,
        parsed = parsed,
        score_before = private$.current_score,
        turn_score = if (is_bust) 0L else as.integer(turn_score),
        is_bust = is_bust,
        num_darts = num_darts
      )

      private$.turns <- append(private$.turns, list(turn))
      private$.darts_thrown <- private$.darts_thrown + num_darts

      if (!is_bust) {
        private$.current_score <- as.integer(potential_score)

        if (private$.current_score == 0L) {
          private$.finished <- TRUE
        }
      }

      invisible(self)
    },

    #' @description
    #' Undo the last turn
    #' @return Invisible self for method chaining.
    undo = function() {
      if (length(private$.turns) == 0) {
        stop("No turns to undo.")
      }

      last_turn <- private$.turns[[length(private$.turns)]]
      private$.current_score <- last_turn$score_before
      private$.darts_thrown <- private$.darts_thrown - last_turn$num_darts
      private$.turns <- private$.turns[-length(private$.turns)]
      private$.finished <- FALSE

      invisible(self)
    },

    #' @description
    #' Check if the game is finished
    #' @return Logical indicating if the game is complete.
    is_finished = function() {
      private$.finished
    },

    #' @description
    #' Get game summary statistics

    #' @return A list containing game statistics.
    summary = function() {
      total_turns <- length(private$.turns)
      total_darts <- private$.darts_thrown

      # Calculate scores (excluding busts for average calculation)
      valid_turns <- Filter(function(t) !t$is_bust, private$.turns)
      total_score <- sum(vapply(
        valid_turns,
        function(t) as.integer(t$turn_score),
        integer(1)
      ))

      # Count doubles attempted and hit
      doubles_attempted <- 0L
      doubles_hit <- 0L

      for (turn in private$.turns) {
        for (i in seq_along(turn$parsed$is_double)) {
          if (turn$parsed$is_double[i]) {
            doubles_attempted <- doubles_attempted + 1L
            # A double "hit" is harder to determine without more context
            # For now, count all doubles thrown as attempted
          }
        }
      }

      # If game is finished, the last dart was a successful double
      if (private$.finished && private$.double_out) {
        doubles_hit <- 1L
      }

      # Three-dart average
      three_dart_avg <- if (total_darts > 0) {
        (private$.starting_score - private$.current_score) / total_darts * 3
      } else {
        0
      }

      list(
        player_name = private$.player_name,
        starting_score = private$.starting_score,
        current_score = private$.current_score,
        is_finished = private$.finished,
        total_turns = total_turns,
        total_darts = total_darts,
        three_dart_average = round(three_dart_avg, 2),
        highest_turn = if (total_turns > 0) {
          max(sapply(private$.turns, function(t) t$turn_score))
        } else {
          0L
        },
        bust_count = sum(vapply(
          private$.turns,
          function(t) isTRUE(t$is_bust),
          logical(1)
        )),
        checkout_darts = if (private$.finished) {
          last_turn <- private$.turns[[length(private$.turns)]]
          last_turn$num_darts
        } else {
          NA_integer_
        },
        double_out = private$.double_out
      )
    },

    #' @description
    #' Get all turns as a data frame

    #' @return A data frame with turn-by-turn information.
    get_turns = function() {
      if (length(private$.turns) == 0) {
        return(data.frame(
          turn_number = integer(),
          darts = character(),
          score_before = integer(),
          turn_score = integer(),
          score_after = integer(),
          is_bust = logical(),
          num_darts = integer(),
          stringsAsFactors = FALSE
        ))
      }

      do.call(rbind, lapply(private$.turns, function(t) {
        data.frame(
          turn_number = t$turn_number,
          darts = paste(t$darts, collapse = ", "),
          score_before = t$score_before,
          turn_score = t$turn_score,
          score_after = if (t$is_bust) {
            t$score_before
          } else {
            t$score_before - t$turn_score
          },
          is_bust = t$is_bust,
          num_darts = t$num_darts,
          stringsAsFactors = FALSE
        )
      }))
    },

    #' @description
    #' Print method for the game
    #' @param ... Additional arguments (unused).
    print = function(...) {
      cat("X01 Darts Game\n")
      cat("==============\n")
      cat("Player:", private$.player_name, "\n")
      cat("Starting Score:", private$.starting_score, "\n")
      cat("Current Score:", private$.current_score, "\n")
      cat("Turns Played:", length(private$.turns), "\n")
      status <- if (private$.finished) {
        "FINISHED!"
      } else {
        "In Progress"
      }
      cat("Status:", status, "\n")
      invisible(self)
    }
  ),

  private = list(
    .starting_score = NULL,
    .current_score = NULL,
    .player_name = NULL,
    .double_out = NULL,
    .turns = NULL,
    .finished = NULL,
    .darts_thrown = NULL
  ),

  active = list(
    #' @field current_score The current remaining score.
    current_score = function() private$.current_score,


    #' @field starting_score The starting score for the game.
    starting_score = function() private$.starting_score,

    #' @field player_name The player's name.
    player_name = function() private$.player_name,

    #' @field turns_played The number of turns played.
    turns_played = function() length(private$.turns)
  )
)
