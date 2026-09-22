# Version 2.6.0
# get_PlayerInfo.R
# Created by: Noah Cornish
# Description: Retrieve OHL player information for a selected season.

#' Get OHL Player Information
#'
#' @description
#' Retrieves player identification and biographical information for a selected
#' OHL season. Results can optionally be filtered by one or more OHL teams.
#'
#' Run \code{get_Seasons()} to view all supported season names.
#'
#' @param season_name Character. The season to retrieve.
#'   Defaults to \code{"2027 Season"}.
#' @param team Optional character vector containing one or more team names.
#'
#' @return A data frame containing OHL player information.
#'
#' @examples
#' \dontrun{
#' # Retrieve all available player information
#' player_info <- get_PlayerInfo("2027 Season")
#'
#' # Filter by one team
#' london_info <- get_PlayerInfo(
#'   season_name = "2027 Season",
#'   team = "London Knights"
#' )
#'
#' # Filter by multiple teams
#' player_subset <- get_PlayerInfo(
#'   season_name = "2027 Season",
#'   team = c("Erie Otters", "Saginaw Spirit")
#' )
#' }
#'
#' @export
get_PlayerInfo <- function(
    season_name = "2027 Season",
    team = NULL
) {

  # Validate the season and retrieve its OHL season ID
  season_id <- .get_season_id(season_name)

  # Validate the optional team argument
  if (!is.null(team) && !is.character(team)) {
    stop(
      "`team` must be NULL or a character vector of team names.",
      call. = FALSE
    )
  }

  # Build the OHL API URL
  url_player <- sprintf(
    paste0(
      "https://lscluster.hockeytech.com/feed/",
      "?feed=modulekit",
      "&view=statviewtype",
      "&type=topscorers",
      "&key=2976319eb44abe94",
      "&fmt=json",
      "&client_code=ohl",
      "&lang=en",
      "&season_id=%s",
      "&first=0",
      "&limit=10000",
      "&sort=active",
      "&stat=all",
      "&order_direction="
    ),
    season_id
  )

  # Retrieve and parse the OHL data
  json_data_player <- tryCatch(
    jsonlite::fromJSON(
      url_player,
      simplifyDataFrame = TRUE
    ),
    error = function(error) {
      stop(
        paste0(
          "OHL player information could not be retrieved for \"",
          season_name,
          "\". ",
          error$message
        ),
        call. = FALSE
      )
    }
  )

  # Extract the player-information table
  raw_player_info <- json_data_player[["SiteKit"]][["Statviewtype"]]

  # Return an empty table when no player information is available
  if (!is.data.frame(raw_player_info) || nrow(raw_player_info) == 0L) {
    warning(
      paste0(
        "No player information is currently available for \"",
        season_name,
        "\"."
      ),
      call. = FALSE
    )

    return(
      data.frame(
        player_id = numeric(),
        name = character(),
        height = character(),
        weight = numeric(),
        birthdate = as.Date(character()),
        team_name = character(),
        team_id = numeric(),
        stringsAsFactors = FALSE
      )
    )
  }

  # Columns required from the OHL API
  required_columns <- c(
    "player_id",
    "name",
    "height",
    "weight",
    "birthdate",
    "team_name",
    "team_id"
  )

  # Identify changes or missing fields in the OHL API
  missing_columns <- setdiff(
    required_columns,
    names(raw_player_info)
  )

  if (length(missing_columns) > 0L) {
    stop(
      paste0(
        "The OHL player data feed is missing required columns: ",
        paste(missing_columns, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }

  # Select the player-information columns
  player_info <- raw_player_info[
    required_columns
  ]

  # Safely convert known numeric fields
  convert_numeric <- function(value) {

    value <- trimws(as.character(value))

    value[value %in% c("", "-", "--", "NA", "N/A")] <- NA_character_

    suppressWarnings(as.numeric(value))
  }

  numeric_columns <- c(
    "player_id",
    "weight",
    "team_id"
  )

  player_info[numeric_columns] <- lapply(
    player_info[numeric_columns],
    convert_numeric
  )

  # Format birthdates
  player_info$birthdate <- as.Date(
    gsub(",", "", player_info$birthdate),
    format = "%B %d %Y"
  )

  # Apply the optional team filter
  if (!is.null(team)) {
    player_info <- player_info[
      player_info$team_name %in% team,
      ,
      drop = FALSE
    ]
  }

  # Sort players by team and name
  if (nrow(player_info) > 0L) {
    player_info <- player_info[
      order(
        player_info$team_name,
        player_info$name,
        na.last = TRUE
      ),
      ,
      drop = FALSE
    ]
  }

  # Remove inherited row numbers
  rownames(player_info) <- NULL

  return(player_info)
}
