# Version 2.6.0
# get_Stats.R
# Created by: Noah Cornish
# Description: Retrieve OHL skater statistics filtered by games played.

#' Get OHL Player Statistics
#'
#' @description
#' Retrieves active skater statistics for a selected OHL season and filters
#' players according to a minimum number of games played. Results can
#' optionally be filtered by one or more OHL teams.
#'
#' Run \code{get_Seasons()} to view all supported season names.
#'
#' @param season_name Character. The season to retrieve.
#'   Defaults to \code{"2027 Season"}.
#' @param min_games Numeric. The minimum number of games played required for
#'   a player to be included. Defaults to 10.
#' @param team Optional character vector containing one or more team names.
#'
#' @return A data frame containing filtered OHL skater statistics.
#'
#' @examples
#' \dontrun{
#' # Players with at least 10 games played
#' stats <- get_Stats("2027 Season")
#'
#' # Include all active skaters
#' stats_all <- get_Stats(
#'   season_name = "2027 Season",
#'   min_games = 0
#' )
#'
#' # Filter by one team
#' stats_london <- get_Stats(
#'   season_name = "2027 Season",
#'   min_games = 0,
#'   team = "London Knights"
#' )
#'
#' # Filter by multiple teams
#' stats_subset <- get_Stats(
#'   season_name = "2027 Season",
#'   min_games = 0,
#'   team = c("Erie Otters", "Saginaw Spirit")
#' )
#' }
#'
#' @export
get_Stats <- function(
    season_name = "2027 Season",
    min_games = 10,
    team = NULL
) {

  # Validate the minimum-games argument
  if (
    !is.numeric(min_games) ||
    length(min_games) != 1L ||
    is.na(min_games) ||
    !is.finite(min_games) ||
    min_games < 0
  ) {
    stop(
      "`min_games` must be one non-negative numeric value.",
      call. = FALSE
    )
  }

  # Retrieve the processed raw skater statistics
  LeagueStats <- get_RawStats(
    season_name = season_name,
    team = team
  )

  # Return immediately if no statistics are available
  if (nrow(LeagueStats) == 0L) {
    return(LeagueStats)
  }

  # Apply the minimum-games requirement
  LeagueStats <- LeagueStats[
    !is.na(LeagueStats$GP) &
      LeagueStats$GP >= min_games,
    ,
    drop = FALSE
  ]

  # Remove inherited row numbers
  rownames(LeagueStats) <- NULL

  return(LeagueStats)
}
