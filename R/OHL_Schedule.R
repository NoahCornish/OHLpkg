# Version 2.6.0
# get_Schedule.R
# Created by: Noah Cornish
# Description: Get the current OHL regular season schedule.

#' Get the Current OHL Schedule
#'
#' @description
#' Retrieves the current OHL regular season schedule.
#'
#' @return A data frame containing the current OHL regular season schedule.
#'
#' @examples
#' \dontrun{
#' schedule <- get_Schedule()
#' head(schedule)
#' }
#'
#' @export
get_Schedule <- function() {

  # Current 2026-27 OHL regular-season schedule
  url_schedule <- paste0(
    "https://lscluster.hockeytech.com/feed/",
    "?feed=modulekit",
    "&view=scorebar",
    "&client_code=ohl",
    "&numberofdaysahead=100",
    "&numberofdaysback=90",
    "&season_id=88",
    "&team_id=",
    "&key=f1aa699db3d81487"
  )

  # Retrieve schedule data
  json_data_schedule <- jsonlite::fromJSON(
    url_schedule,
    simplifyDataFrame = TRUE
  )

  # Extract the schedule table
  Schedule <- json_data_schedule[["SiteKit"]][["Scorebar"]]

  # Keep games from the 2026-27 regular season
  Schedule <- Schedule[
    Schedule$Date >= "2026-09-18",
    c(
      "Date",
      "ID",
      "ScheduledFormattedTime",
      "HomeLongName",
      "HomeGoals",
      "VisitorLongName",
      "VisitorGoals"
    ),
    drop = FALSE
  ]

  # Remove inherited row numbers
  rownames(Schedule) <- NULL

  return(Schedule)
}
