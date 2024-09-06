# Version 2.3.0
# OHL_Player_Info.R
# Created by: Noah Cornish
# This function returns player information data (no stats).


# Load necessary libraries
library(httr)
library(jsonlite)
library(dplyr)
library(tibble)

# Function to retrieve player information
get_PlayerInfo <- function(season_name = "2025 Season") {

  # Map the updated season names to their respective season_ids
  season_ids <- c("2025 Season" = 79,
                  "2025 Pre-Season" = 78,
                  "2024 Season" = 76,
                  "2024 Playoffs" = 77,
                  "2024 Pre-Season" = 75,
                  "2023 Season" = 73,
                  "2023 Playoffs" = 74,
                  "2022 Season" = 70,
                  "2022 Playoffs" = 71,
                  "2020 Season" = 68,
                  "2019 Season" = 63,
                  "2019 Playoffs" = 66,
                  "2018 Season" = 60,
                  "2018 Playoffs" = 61,
                  "2017 Season" = 56,
                  "2017 Playoffs" = 57,
                  "2016 Season" = 54,
                  "2016 Playoffs" = 55,
                  "2015 Season" = 51,
                  "2015 Playoffs" = 52,
                  "2014 Season" = 49,
                  "2014 Playoffs" = 50,
                  "2013 Season" = 46,
                  "2013 Playoffs" = 48,
                  "2012 Season" = 44,
                  "2012 Playoffs" = 45,
                  "2011 Season" = 42,
                  "2011 Playoffs" = 43,
                  "2010 Season" = 38,
                  "2010 Playoffs" = 41,
                  "2009 Season" = 35,
                  "2009 Playoffs" = 37,
                  "2008 Season" = 32,
                  "2008 Playoffs" = 34,
                  "2007 Season" = 29,
                  "2007 Playoffs" = 31,
                  "2006 Season" = 26,
                  "2006 Playoffs" = 28,
                  "2005 Season" = 24,
                  "2005 Playoffs" = 25,
                  "2004 Season" = 21,
                  "2004 Playoffs" = 23,
                  "2003 Season" = 17,
                  "2003 Playoffs" = 20,
                  "2002 Season" = 14,
                  "2002 Playoffs" = 15,
                  "2001 Season" = 11,
                  "2001 Playoffs" = 12,
                  "2000 Season" = 9,
                  "2000 Playoffs" = 10,
                  "1999 Season" = 6,
                  "1999 Playoffs" = 7,
                  "1998 Season" = 4,
                  "1998 Playoffs" = 5)

  # Validate the input season_name and retrieve the corresponding season_id
  if (!season_name %in% names(season_ids)) {
    stop("Invalid season name. Please refer to package help.")
  }

  season_id <- season_ids[season_name]

  # Construct the URL with the dynamic season_id
  url_player <- paste0("https://lscluster.hockeytech.com/feed/?feed=modulekit&view=statviewtype&type=topscorers&key=2976319eb44abe94&fmt=json&client_code=ohl&lang=en&league_code=&season_id=",
                       season_id,
                       "&first=0&limit=10000&sort=active&stat=all&order_direction=")

  # Retrieve and process the JSON data
  json_data_player <- fromJSON(url_player, simplifyDataFrame = TRUE)

  # Select relevant player information
  player_info <- as_tibble(json_data_player[["SiteKit"]][["Statviewtype"]]) %>%
    select(player_id, name, height, weight, birthdate, team_name, team_id)

  return(player_info)
}


# Main code execution
#player_info <- get_PlayerInfo(argument)
#player_info <- get_PlayerInfo("2024 Season")

