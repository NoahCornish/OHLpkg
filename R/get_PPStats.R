# Version 2.7.0
# get_PPStats.R
# Created by: Noah Cornish
# Description: Retrieve power-play OHL skater statistics.

#' Get OHL Power-Play Player Statistics
#'
#' @description
#' Retrieves active skater statistics for a selected OHL season and presents
#' each player's power-play goals, assists, and points.
#'
#' Players can be filtered according to a minimum number of games played and
#' by one or more OHL teams.
#'
#' Run \code{get_Seasons()} to view all supported season names.
#'
#' @param season_name Character. The season to retrieve.
#'   Defaults to \code{"2027 Season"}.
#' @param team Optional character vector containing one or more team names.
#' @param min_games Numeric. The minimum number of games played required for
#'   a player to be included. Defaults to 10.
#'
#' @return A data frame containing power-play OHL player statistics.
#'
#' @examples
#' \dontrun{
#' # Players with at least 10 games played
#' pp_stats <- get_PPStats("2027 Season")
#'
#' # Include all active skaters
#' all_pp_stats <- get_PPStats(
#'   season_name = "2027 Season",
#'   min_games = 0
#' )
#'
#' # Filter by one team
#' london_pp <- get_PPStats(
#'   season_name = "2027 Season",
#'   team = "London Knights",
#'   min_games = 0
#' )
#'
#' # Retrieve playoff statistics
#' playoff_pp <- get_PPStats(
#'   season_name = "2026 Playoffs",
#'   min_games = 0
#' )
#' }
#'
#' @export
get_PPStats <- function(
    season_name = "2027 Season",
    team = NULL,
    min_games = 10
) {

  # Retrieve processed skater statistics
  LeagueStats <- get_Stats(
    season_name = season_name,
    min_games = min_games,
    team = team
  )

  # Return an empty table with the expected structure when no data are found
  if (nrow(LeagueStats) == 0L) {
    return(
      data.frame(
        Name = character(),
        BD = as.Date(character()),
        Pos = character(),
        Team = character(),
        GP = numeric(),
        PPG = numeric(),
        PPA = numeric(),
        PPP = numeric(),
        `PPP/G` = numeric(),
        `PPP%` = numeric(),
        check.names = FALSE
      )
    )
  }

  # Calculate power-play points
  PPP <- LeagueStats$PPG + LeagueStats$PPA

  # Avoid division by zero for players with no games or points
  PPP_per_game <- ifelse(
    LeagueStats$GP > 0,
    round(PPP / LeagueStats$GP, 2),
    NA_real_
  )

  PPP_percentage <- ifelse(
    LeagueStats$PTS > 0,
    round((PPP / LeagueStats$PTS) * 100),
    NA_real_
  )

  # Build the final power-play statistics table
  PPStats <- data.frame(
    Name = LeagueStats$Name,
    BD = LeagueStats$BD,
    Pos = LeagueStats$Pos,
    Team = LeagueStats$Team,
    GP = LeagueStats$GP,
    PPG = LeagueStats$PPG,
    PPA = LeagueStats$PPA,
    PPP = PPP,
    `PPP/G` = PPP_per_game,
    `PPP%` = PPP_percentage,
    check.names = FALSE
  )

  # Sort players by power-play points
  PPStats <- PPStats[
    order(
      -PPStats$PPP,
      -PPStats$PPG,
      PPStats$Name,
      na.last = TRUE
    ),
    ,
    drop = FALSE
  ]

  # Remove inherited row numbers
  rownames(PPStats) <- NULL

  return(PPStats)
}
