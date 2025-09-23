# Version 2.5.0
# get_EVStats.R
# Created by: Noah Cornish
# Description: Get even-strength player stats for a given season with optional team filter.

#' Get even-strength player stats
#'
#' @description Retrieves statistics for players at even strength (EV) for the specified season,
#' filtering out players with too few games.
#'
#' @param season_name Character. The season to fetch stats for, e.g. "2026 Season".
#' @param team Optional character vector of team names to filter
#'        (e.g., "London Knights" or c("Erie Otters", "Saginaw Spirit")).
#'
#' @return A data frame with even-strength player statistics.
#' @examples
#' ev_stats <- get_EVStats("2026 Season")
#' head(ev_stats)
#'
#' knights_ev <- get_EVStats("2026 Season", team = "London Knights")
#' head(knights_ev)
#' @export
get_EVStats <- function(season_name = "2026 Season", team = NULL) {

  library(jsonlite)
  library(dplyr)
  library(stringr)

  # Map season names to their respective season_ids
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

  # Validate season_name
  if (!season_name %in% names(season_ids)) {
    stop("Invalid season name. Please refer to package help.")
  }

  season_id <- season_ids[season_name]

  # API URL
  url_reg <- sprintf(
    "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=statviewtype&type=topscorers&key=2976319eb44abe94&fmt=json&client_code=ohl&lang=en&season_id=%s&first=0&limit=50000&sort=active&stat=all&order_direction=",
    season_id
  )

  # Fetch data
  json_data <- fromJSON(url_reg, simplifyDataFrame = TRUE)

  # Build df
  df <- json_data[["SiteKit"]][["Statviewtype"]] %>%
    select(rank, player_id:num_teams) %>%
    select(-c(birthtown, birthprov, birthcntry,
              loose_ball_recoveries, caused_turnovers, turnovers,
              phonetic_name, last_years_club, suspension_games_remaining,
              suspension_indefinite)) %>%
    mutate(player_id = as.numeric(player_id)) %>%
    mutate(across(active:age, as.numeric)) %>%
    mutate(across(rookie:jersey_number, as.numeric)) %>%
    mutate(team_id = as.numeric(team_id)) %>%
    mutate(across(games_played:faceoff_pct, as.numeric)) %>%
    mutate(across(shots_on:num_teams, as.numeric)) %>%
    mutate(birthdate_year = str_split(birthdate_year, "\\'", simplify = TRUE, n = 2)[,2]) %>%
    mutate(birthdate_year = as.numeric(birthdate_year),
           birthdate_year = 2000 + birthdate_year)

  LeagueStats <- df %>%
    select(Name = "name", Rookie = "rookie", JN = "jersey_number",
           BD = "birthdate", BD_Y = "birthdate_year", Hgt = "height",
           Wgt = "weight", Pos = "position", Team = "team_name",
           GP = "games_played", G = "goals", A = "assists",
           PTS = "points", `Pts/G` = "points_per_game", `+/-` = "plus_minus",
           PPG = "power_play_goals", PPA = "power_play_assists",
           PPP = "power_play_points", SHG = "short_handed_goals",
           SHA = "short_handed_assists", SHPTS = "short_handed_points",
           GWG = "game_winning_goals", ENG = "empty_net_goals",
           PIM = "penalty_minutes", Active = "active") %>%
    filter(Active == 1, GP > 9, Pos != "G") %>%
    mutate(PPP = PPG + PPA)

  # Clean rookie flag + birthdate
  LeagueStats$Rookie <- ifelse(LeagueStats$Rookie == 1, "YES", "NO")
  LeagueStats$BD <- as.Date(as.POSIXct(gsub(",", "", LeagueStats$BD), format = "%B %d %Y"))

  # Compute EV stats
  EVStats <- LeagueStats %>%
    select(Name, BD, Pos, Team, GP, G, A, PTS, PPG, PPA, PPP, SHG, SHA, SHPTS) %>%
    mutate(EVG = G - PPG - SHG,
           EVA = A - PPA - SHA,
           EVPTS = EVG + EVA,
           `EVPTS/G` = round((EVPTS / GP), 2),
           `EVPTS%` = round((EVPTS / PTS) * 100)) %>%
    arrange(desc(EVPTS)) %>%
    select(Name, BD, Pos, Team, GP, EVG, EVA, EVPTS, `EVPTS/G`, `EVPTS%`)

  # Optional team filter
  if (!is.null(team)) {
    EVStats <- EVStats %>% filter(Team %in% team)
  }

  return(EVStats)
}
