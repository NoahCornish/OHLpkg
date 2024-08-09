# Version 2.2.0
# OHL_Goalie_Stats.R
# Created by: Noah Cornish
# This function returns a data frame with goalie stats from the requested season

#Goalies
# GP >9
get_GoalieStats <- function(goalie_stats, season_name = "2024 Season"){

  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)

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

  url_goalies <- sprintf("https://lscluster.hockeytech.com/feed/?feed=modulekit&view=statviewtype&type=topgoalies&key=2976319eb44abe94&fmt=json&client_code=ohl&lang=en&league_code=&season_id=%s&first=0&limit=50000&sort=active&stat=all&order_direction=", season_id)

  # use jsonlite::fromJSON to handle NULL values
  json_data_goalies <- jsonlite::fromJSON(url_goalies, simplifyDataFrame = TRUE)


  # create data frame
  df_goalies <- json_data_goalies[["SiteKit"]][["Statviewtype"]]

  goalie_stats <- df_goalies %>%
    select(name, height, weight, team_name, birthdate,
           games_played, saves, shots, save_percentage,
           shots_against_average, goals_against, goals_against_average,
           shutouts, wins, losses, ot_losses, total_losses,
           shootout_games_played, shootout_wins, shootout_losses,
           penalty_minutes) %>%
    rename(Name = "name",
           Height = "height",
           Weight = "weight",
           Team = "team_name",
           Birthdate = "birthdate",
           GP = "games_played",
           SAV = "saves",
           SH = "shots",
           `SAV%` = "save_percentage",
           `SH%` = "shots_against_average",
           GA = "goals_against",
           GAA = "goals_against_average",
           SO = "shutouts",
           W = "wins",
           L = "losses",
           OTL = "ot_losses",
           TL = "total_losses",
           SOGP = "shootout_games_played",
           SOW = "shootout_wins",
           SOL = "shootout_losses",
           PIM = "penalty_minutes") %>%
    mutate(across(GP:PIM, ~as.numeric(.))) %>%
    filter(GP > 9)

  #fix and adjust the BD column
  goalie_stats$Birthdate <- gsub(",", "", goalie_stats$Birthdate)
  goalie_stats$Birthdate <- as.POSIXct(goalie_stats$Birthdate, format='%B %d %Y')

  goalie_stats$Birthdate <- as.Date(goalie_stats$Birthdate, format = "%d-%b-%Y")

  goalie_stats <- goalie_stats

  return(goalie_stats)
}

