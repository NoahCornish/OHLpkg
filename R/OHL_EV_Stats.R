# Version 2.6.0
# get_EVStats.R
# Created by: Noah Cornish
# Description: Retrieve calculated even-strength OHL skater statistics.

#' Get OHL Even-Strength Player Statistics
#'
#' @description
#' Retrieves active skater statistics for a selected OHL season and calculates
#' even-strength goals, assists, and points by removing power-play and
#' short-handed production from each player's totals.
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
#' @return A data frame containing calculated even-strength player statistics.
#'
#' @examples
#' \dontrun{
#' # Players with at least 10 games played
#' ev_stats <- get_EVStats("2027 Season")
#'
#' # Include all active skaters
#' all_ev_stats <- get_EVStats(
#'   season_name = "2027 Season",
#'   min_games = 0
#' )
#'
#' # Filter by one team
#' london_ev <- get_EVStats(
#'   season_name = "2027 Season",
#'   team = "London Knights",
#'   min_games = 0
#' )
#'
#' # Filter by multiple teams
#' ev_subset <- get_EVStats(
#'   season_name = "2027 Season",
#'   team = c("Erie Otters", "Saginaw Spirit"),
#'   min_games = 0
#' )
#' }
#'
#' @export
get_EVStats <- function(
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

  # Return immediately if no statistics are available
  if (nrow(LeagueStats) == 0L) {
    return(
      data.frame(
        Name = character(),
        BD = as.Date(character()),
        Pos = character(),
        Team = character(),
        GP = numeric(),
        EVG = numeric(),
        EVA = numeric(),
        EVPTS = numeric(),
        `EVPTS/G` = numeric(),
        `EVPTS%` = numeric(),
        check.names = FALSE
      )
    )
  }

  # Calculate even-strength production
  EVG <- (
    LeagueStats$G -
      LeagueStats$PPG -
      LeagueStats$SHG
  )

  EVA <- (
    LeagueStats$A -
      LeagueStats$PPA -
      LeagueStats$SHA
  )

  EVPTS <- EVG + EVA

  # Avoid division by zero for players with no games or points
  EVPTS_per_game <- ifelse(
    LeagueStats$GP > 0,
    round(EVPTS / LeagueStats$GP, 2),
    NA_real_
  )

  EVPTS_percentage <- ifelse(
    LeagueStats$PTS > 0,
    round((EVPTS / LeagueStats$PTS) * 100),
    NA_real_
  )

  # Build the final even-strength statistics table
  EVStats <- data.frame(
    Name = LeagueStats$Name,
    BD = LeagueStats$BD,
    Pos = LeagueStats$Pos,
    Team = LeagueStats$Team,
    GP = LeagueStats$GP,
    EVG = EVG,
    EVA = EVA,
    EVPTS = EVPTS,
    `EVPTS/G` = EVPTS_per_game,
    `EVPTS%` = EVPTS_percentage,
    check.names = FALSE
  )

  # Sort players by even-strength points
  EVStats <- EVStats[
    order(
      -EVStats$EVPTS,
      EVStats$Name,
      na.last = TRUE
    ),
    ,
    drop = FALSE
  ]

  # Remove inherited row numbers
  rownames(EVStats) <- NULL

  return(EVStats)
}
