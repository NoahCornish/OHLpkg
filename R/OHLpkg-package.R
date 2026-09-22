# Version 2.6.0
# OHLpkg-package.R
# Created by: Noah Cornish
# Description: Package-level documentation for OHLpkg.

#' OHLpkg: Ontario Hockey League Statistics Tools
#'
#' @description
#' OHLpkg provides functions for accessing, cleaning, filtering, and analyzing
#' Ontario Hockey League data. Available information includes skater and goalie
#' statistics, schedules, play-by-play events, team information, rookie
#' statistics, draft-eligible players, and special-teams production.
#'
#' Use \code{get_Seasons()} to view the seasons currently supported by the
#' package.
#'
#' @section Main functions:
#' \itemize{
#'   \item \code{get_Seasons()} lists supported seasons and season IDs.
#'   \item \code{get_RawStats()} retrieves all active skaters.
#'   \item \code{get_Stats()} retrieves skaters using a games-played cutoff.
#'   \item \code{get_GoalieStats()} retrieves goalie statistics.
#'   \item \code{get_EVStats()} calculates even-strength production.
#'   \item \code{get_SHStats()} retrieves short-handed production.
#'   \item \code{get_DYStats()} retrieves draft-eligible skaters.
#'   \item \code{get_RKStats()} retrieves rookie skaters.
#'   \item \code{get_PlayerInfo()} retrieves player information.
#'   \item \code{get_Teams()} retrieves team names.
#'   \item \code{get_Schedule()} retrieves the current OHL schedule.
#'   \item \code{get_GameEvents()} retrieves individual game events.
#' }
#'
#' @keywords internal
"_PACKAGE"
