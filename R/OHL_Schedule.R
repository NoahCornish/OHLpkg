# Version 2.3.0
# OHL_Schedule.R
# Created by: Noah Cornish
# This function returns a data frame with 2024-2025 league schedule


# No minimum data requirements. This lists the full 2024-2025 Regular Season
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

  url_schedule <- "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=scorebar&client_code=ohl&numberofdaysahead=100&numberofdaysback=90&season_id=78&team_id=&key=f1aa699db3d81487"

  json_data_schedule <- jsonlite::fromJSON(url_schedule, simplifyDataFrame = TRUE)

  Schedule <- json_data_schedule[["SiteKit"]][["Scorebar"]] %>%
    filter(Date >= "2023-09-28") %>%
    select(Date, ID, ScheduledFormattedTime,
           HomeLongName, HomeGoals,
           VisitorLongName, VisitorGoals)


  return(Schedule)

}
