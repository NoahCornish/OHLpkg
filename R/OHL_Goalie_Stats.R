# Version 1.7.0
# OHL_Goalie_Stats.R
# Created by: Noah Cornish
# This function returns a data frame with goalie stats from 2023-2024

#Goalies
# GP >9
get_GoalieStats <- function(goalie_stats){

  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)

  url_goalies <- "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=statviewtype&type=topgoalies&key=2976319eb44abe94&fmt=json&client_code=ohl&lang=en&league_code=&season_id=76&first=0&limit=50000&sort=active&stat=all&order_direction="

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

