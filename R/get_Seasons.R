# Version 2.7.0
# OHL_Seasons.R
# Created by: Noah Cornish
# Description: Centralized OHL season names and season IDs.

# Internal season mapping
.ohl_season_ids <- c(
  "2027 Season" = 88,
  "2026 Pre-Season" = 87,
  "2026 Playoffs" = 85,
  "2026 Season" = 83,
  "2025 Pre-Season" = 82,
  "2025 Playoffs" = 81,
  "2025 Season" = 79,
  "2024 Playoffs" = 77,
  "2024 Season" = 76,
  "2024 Pre-Season" = 75,
  "2023 Playoffs" = 74,
  "2023 Season" = 73,
  "2022 Playoffs" = 71,
  "2022 Season" = 70,
  "2020 Season" = 68,
  "2019 Playoffs" = 66,
  "2019 Season" = 63,
  "2018 Playoffs" = 61,
  "2018 Season" = 60,
  "2017 Playoffs" = 57,
  "2017 Season" = 56,
  "2016 Playoffs" = 55,
  "2016 Season" = 54,
  "2015 Playoffs" = 52,
  "2015 Season" = 51,
  "2014 Playoffs" = 50,
  "2014 Season" = 49,
  "2013 Playoffs" = 48,
  "2013 Season" = 46,
  "2012 Playoffs" = 45,
  "2012 Season" = 44,
  "2011 Playoffs" = 43,
  "2011 Season" = 42,
  "2010 Playoffs" = 41,
  "2010 Season" = 38,
  "2009 Playoffs" = 37,
  "2009 Season" = 35,
  "2008 Playoffs" = 34,
  "2008 Season" = 32,
  "2007 Playoffs" = 31,
  "2007 Season" = 29,
  "2006 Playoffs" = 28,
  "2006 Season" = 26,
  "2005 Playoffs" = 25,
  "2005 Season" = 24,
  "2004 Playoffs" = 23,
  "2004 Season" = 21,
  "2003 Playoffs" = 20,
  "2003 Season" = 17,
  "2002 Playoffs" = 15,
  "2002 Season" = 14,
  "2001 Playoffs" = 12,
  "2001 Season" = 11,
  "2000 Playoffs" = 10,
  "2000 Season" = 9,
  "1999 Playoffs" = 7,
  "1999 Season" = 6,
  "1998 Playoffs" = 5,
  "1998 Season" = 4
)


#' View Supported OHL Seasons
#'
#' @description
#' Returns all OHL seasons currently supported by OHLpkg, including the
#' season name, season ID and season type.
#'
#' The season names returned by this function can be supplied to functions
#' such as \code{get_Stats()}, \code{get_RawStats()} and
#' \code{get_GoalieStats()}.
#'
#' @return
#' A data frame containing:
#' \itemize{
#'   \item \code{Season}: The season name used by OHLpkg.
#'   \item \code{SeasonID}: The corresponding OHL season ID.
#'   \item \code{SeasonType}: Regular Season, Playoffs or Pre-Season.
#' }
#'
#' @examples
#' seasons <- get_Seasons()
#' head(seasons)
#'
#' # View regular seasons only
#' subset(seasons, SeasonType == "Regular Season")
#'
#' @export
get_Seasons <- function() {

  season_names <- names(.ohl_season_ids)

  season_types <- ifelse(
    grepl("Pre-Season", season_names),
    "Pre-Season",
    ifelse(
      grepl("Playoffs", season_names),
      "Playoffs",
      "Regular Season"
    )
  )

  data.frame(
    Season = season_names,
    SeasonID = as.integer(unname(.ohl_season_ids)),
    SeasonType = season_types,
    stringsAsFactors = FALSE
  )
}


# Internal season validation and lookup
.get_season_id <- function(season_name) {

  if (length(season_name) != 1L ||
      is.na(season_name) ||
      !is.character(season_name)) {
    stop(
      "`season_name` must be one non-missing character value.",
      call. = FALSE
    )
  }

  if (!season_name %in% names(.ohl_season_ids)) {
    stop(
      paste0(
        "Unknown season_name: \"",
        season_name,
        "\". Run get_Seasons() to view supported seasons."
      ),
      call. = FALSE
    )
  }

  unname(.ohl_season_ids[[season_name]])
}
