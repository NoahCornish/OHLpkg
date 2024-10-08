# Version 2.3.0
# OHL_EV_Stats.R
# Created by: Noah Cornish
# This function returns a data frame with even-strength stats for the 2024-2025 season

# GP > 9
get_EVStats <- function(EVStats) {

  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)

  url_reg <- "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=statviewtype&type=topscorers&key=2976319eb44abe94&fmt=json&client_code=ohl&lang=en&league_code=&season_id=78&first=0&limit=50000&sort=active&stat=all&order_direction="

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
    filter(GP > 9) %>%
    mutate(PPP = PPG + PPA) %>%
    filter(Pos != "G")

  #assign rookie values as YES or No instead of binary (1, 0)
  LeagueStats$Rookie <- gsub('1', 'YES', LeagueStats$Rookie)
  LeagueStats$Rookie <- gsub('0', 'NO', LeagueStats$Rookie)

  #fix and adjust the BD column
  LeagueStats$BD <- gsub(",", "", LeagueStats$BD)
  LeagueStats$BD <- as.POSIXct(LeagueStats$BD, format='%B %d %Y')

  LeagueStats$BD <- as.Date(LeagueStats$BD, format = "%d-%b-%Y")

  EVStats <- LeagueStats %>%
    filter(GP > 9) %>%
    select(
      Name, BD, Pos, Team,
      GP, G, A, PTS, PPG,
      PPA, PPP, SHG, SHA, SHPTS
    ) %>%
    mutate(
      EVG = G - PPG - SHG,
      EVA = A - PPA - SHA,
      EVPTS = EVG + EVA,
      `EVPTS/G` = round((EVPTS / GP), 2),
      `EVPTS%` = round((EVPTS / PTS) * 100)
    ) %>%
    arrange(desc(EVPTS)) %>%  # Sort by EVPTS in descending order
    select(
      Name, BD, Pos, Team,
      GP, EVG, EVA, EVPTS,
      `EVPTS/G`, `EVPTS%`
    )

  return(EVStats)

}
