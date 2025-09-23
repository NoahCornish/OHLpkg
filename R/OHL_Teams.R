# Version 2.5.0
# get_Teams.R
# Created by: Noah Cornish
# Description: Get team information for the current season,
# with optional filtering for one or more teams.

#' Get OHL teams
#'
#' @description Retrieves a data frame with team information for the 2025–2026 season.
#' Users can optionally filter results by team name(s).
#'
#' @param team Optional character vector of team names to filter
#'        (e.g., "London Knights" or c("Erie Otters", "Saginaw Spirit")).
#'
#' @return A data frame with OHL team details for the current season.
#'
#' @examples
#' # Get all current teams
#' teams <- get_Teams()
#' head(teams)
#'
#' # Get just the London Knights
#' knights <- get_Teams(team = "London Knights")
#'
#' # Get multiple specific teams
#' subset <- get_Teams(team = c("Erie Otters", "Saginaw Spirit"))
#'
#' @export
get_Teams <- function(team = NULL) {

  # Load required libraries
  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)
  library(stringr)

  # API endpoint for current season (2026 season_id = 83)
  url_reg <- "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=statviewtype&type=topscorers&key=2976319eb44abe94&fmt=json&client_code=ohl&lang=en&league_code=&season_id=83&first=0&limit=50000&sort=active&stat=all&order_direction="

  # Fetch JSON data
  json_data <- jsonlite::fromJSON(url_reg, simplifyDataFrame = TRUE)

  # Create base data frame
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
    mutate(birthdate_year = str_split(birthdate_year, "\\'", simplify = TRUE, n = 2)[, 2]) %>%
    mutate(birthdate_year = as.numeric(birthdate_year)) %>%
    mutate(birthdate_year = 2000 + birthdate_year)

  # Clean LeagueStats
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
    filter(Active == 1, GP > 9, Pos != "G") %>%
    mutate(PPP = PPG + PPA)

  # Assign rookie values as YES/NO
  LeagueStats$Rookie <- ifelse(LeagueStats$Rookie == 1, "YES", "NO")

  # Fix BD column
  LeagueStats$BD <- gsub(",", "", LeagueStats$BD)
  LeagueStats$BD <- as.POSIXct(LeagueStats$BD, format = "%B %d %Y")
  LeagueStats$BD <- as.Date(LeagueStats$BD, format = "%d-%b-%Y")

  # Extract distinct teams
  Teams <- distinct(LeagueStats, Team)

  # Apply team filter if provided
  if (!is.null(team)) {
    Teams <- Teams %>% filter(Team %in% team)
  }

  return(Teams)
}
