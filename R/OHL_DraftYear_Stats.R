# Version 2.6.0
# get_DYStats.R
# Created by: Noah Cornish
# Description: Retrieve draft-eligible OHL skater statistics.

#' Get OHL Draft-Eligible Skater Statistics
#'
#' @description
#' Retrieves statistics for first-time draft-eligible OHL skaters during a
#' selected season.
#'
#' Draft eligibility is calculated automatically from the year at the
#' beginning of \code{season_name}. For example, players in the
#' \code{"2027 Season"} draft-year group must have birthdates from
#' September 16, 2008, through September 15, 2009.
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
#' @return A data frame containing draft-eligible OHL skater statistics.
#'
#' @examples
#' \dontrun{
#' # Draft-eligible players with at least 10 games played
#' draft_year_stats <- get_DYStats("2027 Season")
#'
#' # Include all draft-eligible players
#' all_draft_year_stats <- get_DYStats(
#'   season_name = "2027 Season",
#'   min_games = 0
#' )
#'
#' # Filter by one team
#' london_draft_year <- get_DYStats(
#'   season_name = "2027 Season",
#'   team = "London Knights",
#'   min_games = 0
#' )
#'
#' # Retrieve draft-eligible playoff statistics
#' playoff_draft_year <- get_DYStats(
#'   season_name = "2026 Playoffs",
#'   min_games = 0
#' )
#' }
#'
#' @export
get_DYStats <- function(
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
    "Rookie",
    "BD",
    "Hgt",
    "Wgt",
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
    "PPP",
    "GWG",
    "ENG",
    "PIM"
  )

  # Return an empty table with the expected structure when no data are found
  if (nrow(LeagueStats) == 0L) {
    return(
      data.frame(
        Name = character(),
        Rookie = character(),
        BD = as.Date(character()),
        Hgt = character(),
        Wgt = numeric(),
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
        PPP = numeric(),
        GWG = numeric(),
        ENG = numeric(),
        PIM = numeric(),
        check.names = FALSE
      )
    )
  }

  # Extract the draft year from the season name
  draft_year <- as.integer(
    substr(season_name, 1L, 4L)
  )

  # Calculate the first-time draft-eligibility birthdate range
  eligibility_start <- as.Date(
    sprintf(
      "%d-09-16",
      draft_year - 19L
    )
  )

  eligibility_end <- as.Date(
    sprintf(
      "%d-09-15",
      draft_year - 18L
    )
  )

  # Identify players inside the draft-eligible birthdate range
  eligible_players <- (
    !is.na(LeagueStats$BD) &
      LeagueStats$BD >= eligibility_start &
      LeagueStats$BD <= eligibility_end
  )

  # Build the draft-year statistics table
  DY <- LeagueStats[
    eligible_players,
    output_columns,
    drop = FALSE
  ]

  # Sort players by points, goals, and name
  if (nrow(DY) > 0L) {
    DY <- DY[
      order(
        -DY$PTS,
        -DY$G,
        DY$Name,
        na.last = TRUE
      ),
      ,
      drop = FALSE
    ]
  }

  # Remove inherited row numbers
  rownames(DY) <- NULL

  return(DY)
}
