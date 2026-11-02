# Version 2.7.0
# get_AllRawStats.R
# Created by: Noah Cornish
# Description: Retrieve all available raw OHL player statistics
# directly from the HockeyTech API.

#' Get All Raw OHL Player Statistics
#'
#' @description
#' Retrieves the complete raw player-statistics dataset returned
#' by the OHL API for a selected season.
#'
#' All original API columns are preserved without renaming,
#' filtering statistics, or converting data types.
#'
#' Results can optionally be filtered by one or more OHL teams.
#'
#' Run \code{get_Seasons()} to view supported seasons.
#'
#' @param season_name Character. The season to retrieve.
#'   Defaults to \code{"2027 Season"}.
#' @param team Optional character vector containing team names.
#'
#' @return A data frame containing every column returned by
#'   the OHL player-statistics API.
#'
#' @examples
#' \dontrun{
#' # Retrieve all available raw statistics
#' raw <- get_AllRawStats("2027 Season")
#'
#' # View every available column
#' names(raw)
#'
#' # Filter by one team
#' london <- get_AllRawStats(
#'   season_name = "2027 Season",
#'   team = "London Knights"
#' )
#'
#' # Filter by multiple teams
#' subset <- get_AllRawStats(
#'   season_name = "2027 Season",
#'   team = c("Erie Otters", "Saginaw Spirit")
#' )
#' }
#'
#' @export
get_AllRawStats <- function(
    season_name = "2027 Season",
    team = NULL
) {

  # Validate season
  season_id <- .get_season_id(season_name)

  # Validate team argument
  if (!is.null(team) && !is.character(team)) {
    stop(
      "`team` must be NULL or a character vector.",
      call. = FALSE
    )
  }

  # Build OHL API URL
  url_reg <- sprintf(
    paste0(
      "https://lscluster.hockeytech.com/feed/",
      "?feed=modulekit",
      "&view=statviewtype",
      "&type=topscorers",
      "&key=2976319eb44abe94",
      "&fmt=json",
      "&client_code=ohl",
      "&lang=en",
      "&league_code=",
      "&season_id=%s",
      "&first=0",
      "&limit=50000",
      "&sort=active",
      "&stat=all",
      "&order_direction="
    ),
    season_id
  )

  # Retrieve complete API response
  json_data <- tryCatch(
    jsonlite::fromJSON(url_reg),
    error = function(error) {
      stop(
        paste0(
          "Unable to retrieve OHL statistics: ",
          error$message
        ),
        call. = FALSE
      )
    }
  )

  # Extract all original statistics
  AllRawStats <- json_data[["SiteKit"]][["Statviewtype"]]

  # Handle unavailable data
  if (!is.data.frame(AllRawStats) ||
      nrow(AllRawStats) == 0L) {
    warning(
      "No statistics available for this season.",
      call. = FALSE
    )
    return(data.frame())
  }

  # Optional team filtering
  if (!is.null(team)) {

    if (!"team_name" %in% names(AllRawStats)) {
      stop(
        "The OHL API did not return `team_name`.",
        call. = FALSE
      )
    }

    AllRawStats <- AllRawStats[
      AllRawStats$team_name %in% team,
      ,
      drop = FALSE
    ]
  }

  # Remove inherited row numbers
  rownames(AllRawStats) <- NULL

  return(AllRawStats)
}
