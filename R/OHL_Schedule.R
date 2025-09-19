# Version 2.4.1
# get_Schedule.R
# Created by: Noah Cornish
# Description: Get the OHL regular season schedule.

#' Get OHL schedule
#'
#' @description Retrieves the OHL regular season schedule for the current season.
#' @return A data frame with the OHL regular season schedule.
#' @examples
#' sched <- get_Schedule()
#' head(sched)
#' @export

get_Schedule <- function(Schedule){

  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)
  library(httr)
  library(purrr)
  library(rvest)
  library(furrr)
  library(devtools)

  url_schedule <- "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=scorebar&client_code=ohl&numberofdaysahead=100&numberofdaysback=90&season_id=83&team_id=&key=f1aa699db3d81487"

  json_data_schedule <- jsonlite::fromJSON(url_schedule, simplifyDataFrame = TRUE)

  Schedule <- json_data_schedule[["SiteKit"]][["Scorebar"]] %>%
    filter(Date >= "2023-09-28") %>%
    select(Date, ID, ScheduledFormattedTime,
           HomeLongName, HomeGoals,
           VisitorLongName, VisitorGoals)


  return(Schedule)

}
