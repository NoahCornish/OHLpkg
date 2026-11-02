# Version 2.7.0
# get_PIMStats.R
# Created by: Noah Cornish
# Description: Retrieve OHL skater penalty-minute statistics.

#' Get OHL Penalty-Minute Statistics
#'
#' @description
#' Retrieves active skater penalty-minute statistics for a selected OHL
#' season.
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
#' @return A data frame containing OHL player penalty-minute statistics.
#'
#' @examples
#' \dontrun{
#' # Players with at least 10 games played
#' pim_stats <- get_PIMStats("2027 Season")
#'
#' # Include all active skaters
#' all_pim_stats <- get_PIMStats(
#'   season_name = "2027 Season",
#'   min_games = 0
#' )
#'
#' # Filter by one team
#' london_pim <- get_PIMStats(
#'   season_name = "2027 Season",
#'   team = "London Knights",
#'   min_games = 0
#' )
#'
#' # Filter by multiple teams
#' pim_subset <- get_PIMStats(
#'   season_name = "2027 Season",
#'   team = c("Erie Otters", "Saginaw Spirit"),
#'   min_games = 0
#' )
#' }
#'
#' @export
get_PIMStats <- function(
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
        PIM = numeric(),
        `PIM/G` = numeric(),
        check.names = FALSE
      )
    )
  }

  # Calculate penalty minutes per game
  PIM_per_game <- ifelse(
    LeagueStats$GP > 0,
    round(LeagueStats$PIM / LeagueStats$GP, 2),
    NA_real_
  )

  # Build the final penalty-minute statistics table
  PIMStats <- data.frame(
    Name = LeagueStats$Name,
    BD = LeagueStats$BD,
    Pos = LeagueStats$Pos,
    Team = LeagueStats$Team,
    GP = LeagueStats$GP,
    PIM = LeagueStats$PIM,
    `PIM/G` = PIM_per_game,
    check.names = FALSE
  )

  # Sort players by penalty minutes
  PIMStats <- PIMStats[
    order(
      -PIMStats$PIM,
      -PIMStats$`PIM/G`,
      PIMStats$Name,
      na.last = TRUE
    ),
    ,
    drop = FALSE
  ]

  # Remove inherited row numbers
  rownames(PIMStats) <- NULL

  return(PIMStats)
}
