# Version 2.6.0
# get_GoalieStats.R
# Created by: Noah Cornish
# Description: Retrieve OHL goalie statistics with optional filters.

#' Get OHL Goalie Statistics
#'
#' @description
#' Retrieves goalie statistics for a selected OHL season. Goalies can be
#' filtered according to a minimum number of games played and by one or more
#' OHL teams.
#'
#' Run \code{get_Seasons()} to view all supported season names.
#'
#' @param season_name Character. The season to retrieve.
#'   Defaults to \code{"2027 Season"}.
#' @param team Optional character vector containing one or more team names.
#' @param min_games Numeric. The minimum number of games played required for
#'   a goalie to be included. Defaults to 10.
#'
#' @return A data frame containing OHL goalie statistics.
#'
#' @examples
#' \dontrun{
#' # Goalies with at least 10 games played
#' goalies <- get_GoalieStats("2027 Season")
#'
#' # Include all goalies
#' all_goalies <- get_GoalieStats(
#'   season_name = "2027 Season",
#'   min_games = 0
#' )
#'
#' # Filter by one team
#' london_goalies <- get_GoalieStats(
#'   season_name = "2027 Season",
#'   team = "London Knights",
#'   min_games = 0
#' )
#'
#' # Filter by multiple teams
#' goalie_subset <- get_GoalieStats(
#'   season_name = "2027 Season",
#'   team = c("Erie Otters", "Saginaw Spirit"),
#'   min_games = 0
#' )
#' }
#'
#' @export
get_GoalieStats <- function(
    season_name = "2027 Season",
    team = NULL,
    min_games = 10
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

  # Validate the minimum-games argument
  if (
    !is.numeric(min_games) ||
    length(min_games) != 1L ||
    is.na(min_games) ||
    !is.finite(min_games) ||
    min_games < 0
  ) {
    stop(
      "`min_games` must be one non-negative numeric value.",
      call. = FALSE
    )
  }

  # Build the OHL API URL
  url_goalies <- sprintf(
    paste0(
      "https://lscluster.hockeytech.com/feed/",
      "?feed=modulekit",
      "&view=statviewtype",
      "&type=topgoalies",
      "&key=2976319eb44abe94",
      "&fmt=json",
      "&client_code=ohl",
      "&lang=en",
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
  json_data_goalies <- tryCatch(
    jsonlite::fromJSON(
      url_goalies,
      simplifyDataFrame = TRUE
    ),
    error = function(error) {
      stop(
        paste0(
          "OHL goalie data could not be retrieved for \"",
          season_name,
          "\". ",
          error$message
        ),
        call. = FALSE
      )
    }
  )

  # Extract the goalie-statistics table
  raw_goalies <- json_data_goalies[["SiteKit"]][["Statviewtype"]]

  # Return gracefully when a season does not contain goalie statistics
  if (!is.data.frame(raw_goalies) || nrow(raw_goalies) == 0L) {
    warning(
      paste0(
        "No goalie statistics are currently available for \"",
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
    "height",
    "weight",
    "team_name",
    "birthdate",
    "games_played",
    "saves",
    "shots",
    "save_percentage",
    "shots_against_average",
    "goals_against",
    "goals_against_average",
    "shutouts",
    "wins",
    "losses",
    "ot_losses",
    "total_losses",
    "shootout_games_played",
    "shootout_wins",
    "shootout_losses",
    "penalty_minutes"
  )

  # Identify changes or missing fields in the OHL API
  missing_columns <- setdiff(
    required_columns,
    names(raw_goalies)
  )

  if (length(missing_columns) > 0L) {
    stop(
      paste0(
        "The OHL goalie data feed is missing required columns: ",
        paste(missing_columns, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }

  # Select only the columns used by this function
  goalie_stats <- raw_goalies[required_columns]

  # Apply readable column names
  names(goalie_stats) <- c(
    "Name",
    "Height",
    "Weight",
    "Team",
    "Birthdate",
    "GP",
    "SAV",
    "SH",
    "SAV%",
    "SH%",
    "GA",
    "GAA",
    "SO",
    "W",
    "L",
    "OTL",
    "TL",
    "SOGP",
    "SOW",
    "SOL",
    "PIM"
  )

  # Safely convert known numeric fields
  convert_numeric <- function(value) {

    value <- trimws(as.character(value))

    value[value %in% c("", "-", "--", "NA", "N/A")] <- NA_character_

    suppressWarnings(as.numeric(value))
  }

  numeric_columns <- c(
    "Weight",
    "GP",
    "SAV",
    "SH",
    "SAV%",
    "SH%",
    "GA",
    "GAA",
    "SO",
    "W",
    "L",
    "OTL",
    "TL",
    "SOGP",
    "SOW",
    "SOL",
    "PIM"
  )

  goalie_stats[numeric_columns] <- lapply(
    goalie_stats[numeric_columns],
    convert_numeric
  )

  # Format birthdates
  goalie_stats$Birthdate <- as.Date(
    gsub(",", "", goalie_stats$Birthdate),
    format = "%B %d %Y"
  )

  # Apply the minimum-games requirement
  goalie_stats <- goalie_stats[
    !is.na(goalie_stats$GP) &
      goalie_stats$GP >= min_games,
    ,
    drop = FALSE
  ]

  # Apply the optional team filter
  if (!is.null(team)) {
    goalie_stats <- goalie_stats[
      goalie_stats$Team %in% team,
      ,
      drop = FALSE
    ]
  }

  # Remove inherited row numbers
  rownames(goalie_stats) <- NULL

  return(goalie_stats)
}
