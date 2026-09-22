# Version 2.6.0
# get_RawStats.R
# Created by: Noah Cornish
# Description: Retrieve raw OHL skater statistics with an optional team filter.

#' Get Raw OHL Player Statistics
#'
#' @description
#' Retrieves all active skater statistics for a selected OHL season without
#' applying a minimum-games requirement. Results can optionally be filtered
#' by one or more OHL teams.
#'
#' Run \code{get_Seasons()} to view all supported season names.
#'
#' @param season_name Character. The season to retrieve.
#'   Defaults to \code{"2027 Season"}.
#' @param team Optional character vector containing one or more team names.
#'
#' @return A data frame containing raw OHL skater statistics.
#'
#' @examples
#' \dontrun{
#' # All active skaters
#' raw <- get_RawStats("2027 Season")
#'
#' # Filter by one team
#' raw_london <- get_RawStats(
#'   season_name = "2027 Season",
#'   team = "London Knights"
#' )
#'
#' # Filter by multiple teams
#' raw_subset <- get_RawStats(
#'   season_name = "2027 Season",
#'   team = c("Erie Otters", "Saginaw Spirit")
#' )
#' }
#'
#' @export
get_RawStats <- function(
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

  # Retrieve and parse the OHL data
  json_data <- tryCatch(
    jsonlite::fromJSON(
      url_reg,
      simplifyDataFrame = TRUE
    ),
    error = function(error) {
      stop(
        paste0(
          "OHL data could not be retrieved for \"",
          season_name,
          "\". ",
          error$message
        ),
        call. = FALSE
      )
    }
  )

  # Extract the player-statistics table
  raw_data <- json_data[["SiteKit"]][["Statviewtype"]]

  # Return gracefully when a season does not contain statistics yet
  if (!is.data.frame(raw_data) || nrow(raw_data) == 0L) {
    warning(
      paste0(
        "No player statistics are currently available for \"",
        season_name,
        "\"."
      ),
      call. = FALSE
    )

    return(data.frame())
  }

  # Columns required from the OHL API
  required_columns <- c(
    "name",
    "rookie",
    "jersey_number",
    "birthdate",
    "height",
    "weight",
    "position",
    "team_name",
    "games_played",
    "goals",
    "assists",
    "points",
    "points_per_game",
    "plus_minus",
    "power_play_goals",
    "power_play_assists",
    "power_play_points",
    "short_handed_goals",
    "short_handed_assists",
    "short_handed_points",
    "game_winning_goals",
    "empty_net_goals",
    "penalty_minutes",
    "active"
  )

  # Identify changes or missing fields in the OHL API
  missing_columns <- setdiff(
    required_columns,
    names(raw_data)
  )

  if (length(missing_columns) > 0L) {
    stop(
      paste0(
        "The OHL data feed is missing required columns: ",
        paste(missing_columns, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }

  # Select only the columns used by this function
  RawLeagueStats <- raw_data[required_columns]

  # Apply readable column names
  names(RawLeagueStats) <- c(
    "Name",
    "Rookie",
    "JN",
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
    "SHG",
    "SHA",
    "SHPTS",
    "GWG",
    "ENG",
    "PIM",
    "Active"
  )

  # Safely convert known numeric fields
  convert_numeric <- function(value) {

    value <- trimws(as.character(value))

    value[value %in% c("", "-", "--", "NA", "N/A")] <- NA_character_

    suppressWarnings(as.numeric(value))
  }

  numeric_columns <- c(
    "Rookie",
    "JN",
    "Wgt",
    "GP",
    "G",
    "A",
    "PTS",
    "Pts/G",
    "+/-",
    "PPG",
    "PPA",
    "PPP",
    "SHG",
    "SHA",
    "SHPTS",
    "GWG",
    "ENG",
    "PIM",
    "Active"
  )

  RawLeagueStats[numeric_columns] <- lapply(
    RawLeagueStats[numeric_columns],
    convert_numeric
  )

  # Format birthdates
  RawLeagueStats$BD <- as.Date(
    gsub(",", "", RawLeagueStats$BD),
    format = "%B %d %Y"
  )

  # Calculate birth year from the complete birthdate
  RawLeagueStats$BD_Y <- as.integer(
    format(RawLeagueStats$BD, "%Y")
  )

  # Position birth year directly after birthdate
  output_order <- c(
    "Name",
    "Rookie",
    "JN",
    "BD",
    "BD_Y",
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
    "SHG",
    "SHA",
    "SHPTS",
    "GWG",
    "ENG",
    "PIM",
    "Active"
  )

  RawLeagueStats <- RawLeagueStats[output_order]

  # Recalculate power-play points
  RawLeagueStats$PPP <- (
    RawLeagueStats$PPG +
      RawLeagueStats$PPA
  )

  # Convert the rookie indicator to readable values
  RawLeagueStats$Rookie <- ifelse(
    RawLeagueStats$Rookie == 1,
    "YES",
    "NO"
  )

  # Keep active skaters and remove goaltenders
  keep_players <- (
    RawLeagueStats$Active == 1 &
      RawLeagueStats$Pos != "G"
  )

  keep_players[is.na(keep_players)] <- FALSE

  RawLeagueStats <- RawLeagueStats[
    keep_players,
    ,
    drop = FALSE
  ]

  # Apply the optional team filter
  if (!is.null(team)) {
    RawLeagueStats <- RawLeagueStats[
      RawLeagueStats$Team %in% team,
      ,
      drop = FALSE
    ]
  }

  # Remove inherited row numbers
  rownames(RawLeagueStats) <- NULL

  return(RawLeagueStats)
}
