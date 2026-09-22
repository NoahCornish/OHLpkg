# Version 2.6.0
# get_Teams.R
# Created by: Noah Cornish
# Description: Retrieve OHL team names for a selected season.

#' Get OHL Teams
#'
#' @description
#' Retrieves the names of OHL teams represented in the player statistics for
#' a selected season. Results can optionally be filtered by one or more team
#' names.
#'
#' Run \code{get_Seasons()} to view all supported season names.
#'
#' @param team Optional character vector containing one or more team names.
#' @param season_name Character. The season to retrieve.
#'   Defaults to \code{"2027 Season"}.
#'
#' @return A data frame containing OHL team names.
#'
#' @examples
#' \dontrun{
#' # Retrieve all current teams
#' teams <- get_Teams()
#'
#' # Filter by one team
#' london <- get_Teams(
#'   team = "London Knights"
#' )
#'
#' # Filter by multiple teams
#' team_subset <- get_Teams(
#'   team = c("Erie Otters", "Saginaw Spirit")
#' )
#'
#' # Retrieve teams from another supported season
#' previous_teams <- get_Teams(
#'   season_name = "2026 Season"
#' )
#' }
#'
#' @export
get_Teams <- function(
    team = NULL,
    season_name = "2027 Season"
) {

  # Retrieve active skater information for the selected season
  LeagueStats <- get_RawStats(
    season_name = season_name,
    team = team
  )

  # Return an empty table when no team information is available
  if (
    nrow(LeagueStats) == 0L ||
    !"Team" %in% names(LeagueStats)
  ) {
    return(
      data.frame(
        Team = character(),
        stringsAsFactors = FALSE
      )
    )
  }

  # Extract unique, non-missing team names
  team_names <- unique(
    LeagueStats$Team[
      !is.na(LeagueStats$Team) &
        nzchar(LeagueStats$Team)
    ]
  )

  # Sort teams alphabetically
  team_names <- sort(team_names)

  # Build the final team table
  Teams <- data.frame(
    Team = team_names,
    stringsAsFactors = FALSE
  )

  rownames(Teams) <- NULL

  return(Teams)
}
