# Version 2.4.1
# get_DYStats.R
# Created by: Noah Cornish
# Description: Get draft-eligible skater stats for a given season.

#' Get draft-eligible skater stats
#'
#' @description Retrieves statistics for draft-eligible skaters (DY) for the specified season.
#' Works for seasons 2015 → 2026.
#' @param season_name Character. The season to fetch stats for, e.g. "2026 Season".
#' @return A data frame with draft-eligible skater statistics.
#' @examples
#' dy <- get_DYStats("2026 Season")
#' head(dy)
#' @export

get_DYStats <- function(DYStats, season_name = "2026 Season") {

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
  season_ids <- c("2026 Season" = 83,
                  "2025 Playoffs" = 81,
                  "2025 Season" = 79,
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
                  "2015 Playoffs" = 52)

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

  DY <- LeagueStats %>%
    # Adjust birthdate range based on the season_name
    filter(
      if (startsWith(season_name, "2026")) {
        BD >= as.Date("2007-09-16") & BD <= as.Date("2008-09-15")
      } else if (startsWith(season_name, "2025")) {
        BD >= as.Date("2006-09-16") & BD <= as.Date("2007-09-15")
      } else if (startsWith(season_name, "2024")) {
        BD >= as.Date("2005-09-16") & BD <= as.Date("2006-09-15")
      } else if (startsWith(season_name, "2023")) {
        BD >= as.Date("2004-09-16") & BD <= as.Date("2005-09-15")
      } else if (startsWith(season_name, "2022")) {
        BD >= as.Date("2003-09-16") & BD <= as.Date("2004-09-15")
      } else if (startsWith(season_name, "2021")) {
        BD >= as.Date("2002-09-16") & BD <= as.Date("2003-09-15")
      } else if (startsWith(season_name, "2020")) {
        BD >= as.Date("2001-09-16") & BD <= as.Date("2002-09-15")
      } else if (startsWith(season_name, "2019")) {
        BD >= as.Date("2000-09-16") & BD <= as.Date("2001-09-15")
      } else if (startsWith(season_name, "2018")) {
        BD >= as.Date("1999-09-16") & BD <= as.Date("2000-09-15")
      } else if (startsWith(season_name, "2017")) {
        BD >= as.Date("1998-09-16") & BD <= as.Date("1999-09-15")
      } else if (startsWith(season_name, "2016")) {
        BD >= as.Date("1997-09-16") & BD <= as.Date("1998-09-15")
      } else if (startsWith(season_name, "2015")) {
        BD >= as.Date("1996-09-16") & BD <= as.Date("1997-09-15")
      } else {
        stop("Season not supported for dynamic birthdate range adjustment.")
      }
    ) %>%
    select(Name, Rookie, BD, Hgt, Wgt, Pos, Team,
           GP, G, A, PTS, `Pts/G`, `+/-`, PPG,
           PPA, PPP, GWG, ENG, PIM)


  DYStats <- DY


  return(DYStats)
}

