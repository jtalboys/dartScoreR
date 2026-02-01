#' dartScoreR: A Package for X01 Darts Game Scoring
#'
#' @description
#' The dartScoreR package provides an R6 class-based system for playing
#' and analyzing X01 darts games (301, 501, etc.). It handles score tracking,
#' turn management, bust detection, and provides comprehensive game statistics.
#'
#' @section Main Class:
#' \describe{
#'   \item{\code{\link{darts}}}{The primary R6 class for managing a darts
#'   game}
#' }
#'
#' @section Utility Functions:
#' \describe{
#'   \item{\code{\link{parse_darts}}}{Parse dart notation strings to scores}
#'   \item{\code{\link{is_valid_dart_score}}}{Validate dart scores}
#'   \item{\code{\link{get_valid_dart_scores}}}{Get all valid single-dart
#'   scores}
#'   \item{\code{\link{get_checkout_doubles}}}{Get all valid checkout doubles}
#'   \item{\code{\link{max_turn_score}}}{Get maximum possible turn score}
#' }
#'
#' @docType package
#' @name dartScoreR-package
#' @aliases dartScoreR
#'
#' @importFrom R6 R6Class
"_PACKAGE"
