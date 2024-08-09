# Version 2.2.0
# OHL_Player_Stats.R
# Created by: Noah Cornish
# This function returns a data frame with the entire league statistics

# GP > 9
get_RawStats <- function(RawLeagueStats, season_name = "2024 Season") {

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

  # Use the correct season_id in the URL
  url_reg <- sprintf("https://lscluster.hockeytech.com/feed/?feed=modulekit&view=statviewtype&type=topscorers&key=2976319eb44abe94&fmt=json&client_code=ohl&lang=en&league_code=&season_id=%s&first=0&limit=50000&sort=active&stat=all&order_direction=", season_id)


  # use jsonlite::fromJSON to handle NULL values
  json_data <- jsonlite::fromJSON(url_reg, simplifyDataFrame = TRUE)


  # create data frame
  df <- json_data[["SiteKit"]][["Statviewtype"]] %>%
    select(rank, player_id:num_teams) %>%
    select(-c(birthtown, birthprov, birthcntry,
              loose_ball_recoveries, caused_turnovers, turnovers,
              phonetic_name, last_years_club, suspension_games_remaining,
              suspension_indefinite)) %>%
    mutate(player_id = as.numeric(player_id)) %>%
    mutate(across(active:age, ~as.numeric(.))) %>%
    mutate(across(rookie:jersey_number, ~as.numeric(.))) %>%
    mutate(team_id = as.numeric(team_id)) %>%
    mutate(across(games_played:faceoff_pct, ~as.numeric(.))) %>%
    mutate(across(shots_on:num_teams, ~as.numeric(.))) %>%
    mutate(birthdate_year = stringr::str_split(birthdate_year,
                                               "\\'", simplify = TRUE, n = 2)[,2]) %>%
    mutate(birthdate_year = as.numeric(birthdate_year)) %>%
    mutate(birthdate_year = 2000 + birthdate_year)



  # create data frame with columns required for tableau viz
  LeagueStats <- df %>%
    select(Name = "name",
           Rookie = "rookie",
           JN = "jersey_number",
           BD = "birthdate",
           BD_Y = "birthdate_year",
           Hgt = "height",
           Wgt = "weight",
           Pos = "position",
           Team = "team_name",
           GP = "games_played",
           G = "goals",
           A = "assists",
           PTS = "points",
           `Pts/G` = "points_per_game",
           `+/-` = "plus_minus",
           PPG = "power_play_goals",
           PPA = "power_play_assists",
           PPP = "power_play_points",
           SHG = "short_handed_goals",
           SHA = "short_handed_assists",
           SHPTS = "short_handed_points",
           GWG = "game_winning_goals",
           ENG = "empty_net_goals",
           PIM = "penalty_minutes",
           Active = "active") %>%
    filter(Active == 1) %>%
    #filter(GP > 9) %>%
    mutate(PPP = PPG + PPA) %>%
    filter(Pos != "G")

  #assign rookie values as YES or No instead of binary (1, 0)
  LeagueStats$Rookie <- gsub('1', 'YES', LeagueStats$Rookie)
  LeagueStats$Rookie <- gsub('0', 'NO', LeagueStats$Rookie)

  #fix and adjust the BD column
  LeagueStats$BD <- gsub(",", "", LeagueStats$BD)
  LeagueStats$BD <- as.POSIXct(LeagueStats$BD, format='%B %d %Y')

  LeagueStats$BD <- as.Date(LeagueStats$BD, format = "%d-%b-%Y")

  RawLeagueStats <- LeagueStats

  return(RawLeagueStats)

}
