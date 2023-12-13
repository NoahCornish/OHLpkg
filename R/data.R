
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

library(rsconnect)
library(ggplot2)
library(tidyverse)
library(janitor)
library(lubridate)
library(RJSONIO)
library(jsonlite)
library(dplyr)
library(scales)

getStats <- function(LeagueStats_2024) {


  url_reg <- "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=statviewtype&type=topscorers&key=2976319eb44abe94&fmt=json&client_code=ohl&lang=en&league_code=&season_id=76&first=0&limit=50000&sort=active&stat=all&order_direction="

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
  LeagueStats_2024 <- df %>%
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
           GWG = "game_winning_goals",
           ENG = "empty_net_goals",
           PIM = "penalty_minutes",
           Active = "active") %>%
    filter(Active == 1)



  LeagueStats_2024 <- LeagueStats_2024 %>%
    mutate(PPP = PPG + PPA) %>%
    mutate(`PPP_Percentage` = (PPP/PTS)*100) %>%
    filter(Pos != "G")


  PowerPlayPointsPerc <- LeagueStats_2024 %>%
    na.omit(PowerPlayPointsPerc$PPP_Percentage)

  #assign rookie values as YES or No instead of binary (1, 0)
  LeagueStats_2024$Rookie <- gsub('1', 'YES', LeagueStats_2024$Rookie)
  LeagueStats_2024$Rookie <- gsub('0', 'NO', LeagueStats_2024$Rookie)

  LeagueStats_2024$PPP_Percentage <- round(LeagueStats_2024$PPP_Percentage ,digit=1)


  #Ranking Players based on G, A, and +/-

  LeagueStats_2024 <- LeagueStats_2024 %>%
    mutate(RNK = (2*G)+(1.5*A)+(1*`+/-`)-(1*PIM))

  LeagueStats_2024$BD <- gsub(",", "", LeagueStats_2024$BD)
  LeagueStats_2024$BD <- as.POSIXct(LeagueStats_2024$BD, format='%B %d %Y')

  LeagueStats_2024$BD <- as.Date(LeagueStats_2024$BD, format = "%d-%b-%Y")




}
