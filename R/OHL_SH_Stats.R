# Version 2.6.0
# get_SHStats.R
# Created by: Noah Cornish
# Description: Retrieve short-handed OHL skater statistics.

#' Get OHL Short-Handed Player Statistics
#'
#' @description
#' Retrieves active skater statistics for a selected OHL season and presents
#' each player's short-handed goals, assists, and points.
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
#' @return A data frame containing short-handed OHL player statistics.
#'
#' @examples
#' \dontrun{
#' # Players with at least 10 games played
#' sh_stats <- get_SHStats("2027 Season")
#'
#' # Include all active skaters
#' all_sh_stats <- get_SHStats(
#'   season_name = "2027 Season",
#'   min_games = 0
#' )
#'
#' # Filter by one team
#' london_sh <- get_SHStats(
#'   season_name = "2027 Season",
#'   team = "London Knights",
#'   min_games = 0
#' )
#'
#' # Retrieve playoff statistics
#' playoff_sh <- get_SHStats(
#'   season_name = "2026 Playoffs",
#'   min_games = 0
#' )
#' }
#'
#' @export
get_SHStats <- function(
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
        SHG = numeric(),
        SHA = numeric(),
        SHPTS = numeric(),
        `SHPTS/G` = numeric(),
        `SHPTS%` = numeric(),
        check.names = FALSE
      )
    )
  }

  # Calculate short-handed points
  SHPTS <- LeagueStats$SHG + LeagueStats$SHA

  # Avoid division by zero for players with no games or points
  SHPTS_per_game <- ifelse(
    LeagueStats$GP > 0,
    round(SHPTS / LeagueStats$GP, 2),
    NA_real_
  )

  SHPTS_percentage <- ifelse(
    LeagueStats$PTS > 0,
    round((SHPTS / LeagueStats$PTS) * 100),
    NA_real_
  )

  # Build the final short-handed statistics table
  SHStats <- data.frame(
    Name = LeagueStats$Name,
    BD = LeagueStats$BD,
    Pos = LeagueStats$Pos,
    Team = LeagueStats$Team,
    GP = LeagueStats$GP,
    SHG = LeagueStats$SHG,
    SHA = LeagueStats$SHA,
    SHPTS = SHPTS,
    `SHPTS/G` = SHPTS_per_game,
    `SHPTS%` = SHPTS_percentage,
    check.names = FALSE
  )

  # Sort players by short-handed points
  SHStats <- SHStats[
    order(
      -SHStats$SHPTS,
      -SHStats$SHG,
      SHStats$Name,
      na.last = TRUE
    ),
    ,
    drop = FALSE
  ]

  # Remove inherited row numbers
  rownames(SHStats) <- NULL

  return(SHStats)
}
