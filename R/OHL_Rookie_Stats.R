# Version 2.6.0
# get_RKStats.R
# Created by: Noah Cornish
# Description: Retrieve OHL rookie skater statistics.

#' Get OHL Rookie Skater Statistics
#'
#' @description
#' Retrieves statistics for active OHL skaters identified as rookies during
#' a selected season.
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
#' @return A data frame containing OHL rookie skater statistics.
#'
#' @examples
#' \dontrun{
#' # Rookies with at least 10 games played
#' rookie_stats <- get_RKStats("2027 Season")
#'
#' # Include all active rookies
#' all_rookies <- get_RKStats(
#'   season_name = "2027 Season",
#'   min_games = 0
#' )
#'
#' # Filter by one team
#' london_rookies <- get_RKStats(
#'   season_name = "2027 Season",
#'   team = "London Knights",
#'   min_games = 0
#' )
#'
#' # Filter by multiple teams
#' rookie_subset <- get_RKStats(
#'   season_name = "2027 Season",
#'   team = c("Erie Otters", "Saginaw Spirit"),
#'   min_games = 0
#' )
#' }
#'
#' @export
get_RKStats <- function(
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

  # Columns returned by this function
  output_columns <- c(
    "Name",
    "BD",
    "Pos",
    "Team",
    "GP",
    "G",
    "A",
    "PTS",
    "Pts/G",
    "+/-",
    "PPG",
    "PPA",
    "GWG",
    "ENG",
    "PIM"
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
        G = numeric(),
        A = numeric(),
        PTS = numeric(),
        `Pts/G` = numeric(),
        `+/-` = numeric(),
        PPG = numeric(),
        PPA = numeric(),
        GWG = numeric(),
        ENG = numeric(),
        PIM = numeric(),
        check.names = FALSE
      )
    )
  }

  # Identify players marked as rookies by the OHL data feed
  rookie_players <- (
    !is.na(LeagueStats$Rookie) &
      LeagueStats$Rookie == "YES"
  )

  # Build the rookie statistics table
  RKStats <- LeagueStats[
    rookie_players,
    output_columns,
    drop = FALSE
  ]

  # Sort rookies by points, goals, and name
  if (nrow(RKStats) > 0L) {
    RKStats <- RKStats[
      order(
        -RKStats$PTS,
        -RKStats$G,
        RKStats$Name,
        na.last = TRUE
      ),
      ,
      drop = FALSE
    ]
  }

  # Remove inherited row numbers
  rownames(RKStats) <- NULL

  return(RKStats)
}
