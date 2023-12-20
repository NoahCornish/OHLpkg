
#v1.2.0


get_Stats <- function(LeagueStats) {

  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)

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

  return(LeagueStats)

}


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


get_DYStats <- function(DYStats){

  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)

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
    filter(BD >= as.Date("2005-09-16") & BD <= as.Date("2006-09-15")) %>%
    select(Name, Rookie, BD, Hgt, Wgt, Pos, Team,
           GP, G, A, PTS, `Pts/G`, `+/-`, PPG,
           PPA, PPP, GWG, ENG, PIM)

}


get_RKStats <- function(RKStats){

  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)

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

  RKStats <- LeagueStats %>%
    filter(Rookie == "YES") %>%
    select(Name, BD, Pos, Team, GP, G,
           A, PTS, `Pts/G`, `+/-`, PPG,
           PPA, GWG, ENG, PIM)

  return(RKStats)

}


get_Teams <- function(Teams){

  library(rsconnect)
  library(ggplot2)
  library(tidyverse)
  library(janitor)
  library(lubridate)
  library(RJSONIO)
  library(jsonlite)
  library(dplyr)
  library(scales)

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

  Teams <- distinct(LeagueStats, Team)

  return(Teams)

}



#' Function to Retrieve U17 Skater Stats
#'
#' This function retrieves U17 skater statistics from EliteProspects API and
#' joins them with drafted player information.
#'
#' @param api_key Your EliteProspects API key.
#' @param draft_year The draft year for which you want to retrieve drafted players.
#' @param birth_year The birth year for which you want to retrieve U17 skater stats.
#'
#' @return A tibble containing U17 skater statistics with draft information.
#'
#' @export

get_u17Skaters <- function(u17Skaters) {

  library(tidyverse)
  library(janitor)
  library(httr)
  library(jsonlite)

  ## CODE TO GET DRAFTED PLAYERS
  url <- "https://api.eliteprospects.com/v1/draft-types/ohl-priority-selection/selections?offset=0&limit=400&sort=-year&apiKey=0cMWKbnl12KJusOFQZjZK7BVLYLP343e"

  api_call <- GET(url)
  api_char <- base::rawToChar(api_call$content)
  api_json <- jsonlite::fromJSON(api_char, flatten = TRUE)

  drafted_players <- as_tibble(api_json[["data"]]) %>%
    clean_names() %>%
    filter(year == 2023) %>%
    select(round, overall,
           drafted_team = "team_name",
           eliteID = "player_id")

  ## CODE TO GET ALL U17 PLAYER STATS EXCLUDING THE OHL
  leagues <- tibble(
    league = c("OJHL", "CCHL", "NOJHL", "GOJHL", "EOJHL",
               "NCJHL", "PJCHL", "OMHA U18",
               "ALLIANCE U18", "GNML", "GTHL U18", "HEO U18")
  )

  ages <- tibble(
    birthYear = c("2007")
  )

  pb_count <- nrow(ages)
  tmsleep <- sample(2:4,1)
  pb <- txtProgressBar(min = 0, max = pb_count, style = 3)

  u17_skaters_stats <- NULL

  for (i in 1:nrow(ages)) {
    birthYear <- as.character(ages[i, 1])

    for (j in 1:nrow(leagues)) {
      league_name <- as.character(leagues[j, 1])

      str1 <- "https://api.eliteprospects.com/v1/leagues/"
      str2 <- "/player-stats?offset=0&limit=400&apiKey=0cMWKbnl12KJusOFQZjZK7BVLYLP343e&player.yearOfBirth="
      str3 <- "&sort=-regularStats.PTS"
      url <- paste0(str1, URLencode(league_name), str2, birthYear, str3)

      print(url) # Print the URL for debugging

      api_call <- GET(url)
      api_char <- base::rawToChar(api_call$content)
      api_json <- jsonlite::fromJSON(api_char, flatten = TRUE)

      df <- as_tibble(api_json[["data"]]) %>%
        clean_names() %>%
        filter(season_start_year == "2023",
               player_position != "G") %>%
        select(team_name,
               eliteID = "player_id",
               name = "player_name",
               pos = "player_position",
               dob = "player_date_of_birth",
               gp = "regular_stats_gp",
               g = "regular_stats_g",
               a = "regular_stats_a",
               pts = "regular_stats_pts",
               pim = "regular_stats_pim",
               ppg = "regular_stats_ppg") %>%
        mutate_if(is.integer, as.numeric) %>%
        mutate_if(is.numeric, ~replace(., is.na(.), 0)) %>%
        mutate(league_name = league_name) %>%
        select(eliteID:dob, team_name, league_name,
               gp:ppg)

      u17_skaters_stats <- bind_rows(u17_skaters_stats, df)

      setTxtProgressBar(pb, i)
    }
  }

  u17Skaters <- u17_skaters_stats %>%
    left_join(drafted_players, by = "eliteID") %>%
    select(eliteID:dob, drafted_team, round, overall, team_name:ppg) %>%
    mutate(across(where(is.numeric), ~replace_na(.x, 0))) %>% # Replace NAs with 0 in numeric columns
    mutate(across(where(is.character), ~replace_na(.x, "not available"))) %>% # Replace NAs with "not available" in character columns
    mutate(drafted_team = case_when(
      drafted_team == "not available" ~ "not drafted",
      TRUE ~ as.character(drafted_team)
    ))

  return(u17Skaters)
}


get_Prospects <- function(prospects_stats){

  library(tidyverse)
  library(janitor)
  library(httr)
  library(jsonlite)
  library(lubridate)

  #link structure
  #https://www.eliteprospects.com/player.php?player=897666

  # get quick info on a player based on eliteID
  prospects <- tibble(
    eliteID = c(897666, 888279, 889660, 883053, 881014,
                969357, 905940, 576966, 876197, 897624,
                800177, 880414, 880831, 618963, 880865,
                880636, 722925)
  )

  # get the number of games
  pb_count <- nrow(prospects)
  #set random system sleep variable
  tmsleep <- sample(2:5,1)
  # set progress bar
  pb <- txtProgressBar(min = 0, max = pb_count, style = 3)

  prospects_stats <- NULL


  # loop through leagues
  for (i in 1:nrow(prospects)) {
    eliteID <- (prospects[i, 1])

    # get stats
    str1 <- "https://api.eliteprospects.com/v1/players/"
    str2 <- "/stats?offset=0&limit=100&sort=season&apiKey=0cMWKbnl12KJusOFQZjZK7BVLYLP343e"
    url <- paste0(str1,eliteID,str2)

    api_call <- GET(url)
    # convert hexidecimal content into character
    api_char <- base::rawToChar(api_call$content)
    # pull json data
    api_json <- jsonlite::fromJSON(api_char, flatten = TRUE)

    stats <- as_tibble(api_json[["data"]]) %>%
      select(teamName, leagueName,
             season = "season.endYear",
             regularStats.GP:regularStats.PPG) %>%
      rename(GP = "regularStats.GP",
             G = "regularStats.G",
             A = "regularStats.A",
             PTS = "regularStats.PTS",
             PPG = "regularStats.PPG",
             PIMS = "regularStats.PIM") %>%
      select(-c("regularStats.PM")) %>%
      mutate(eliteID = eliteID$eliteID) %>%
      mutate(eliteLink = as.character(
        paste0("https://www.eliteprospects.com/player.php?player=",eliteID)
      )) %>%
      arrange(-season)

    # get bio
    str1 <- "https://api.eliteprospects.com/v1/players/"
    str3 <- "?apiKey=0cMWKbnl12KJusOFQZjZK7BVLYLP343e"
    url <- paste0(str1,eliteID,str3)

    api_call <- GET(url)
    # convert hexidecimal content into character
    api_char <- base::rawToChar(api_call$content)
    # pull json data
    api_json <- jsonlite::fromJSON(api_char, flatten = TRUE)

    # use below if you need to adjust based on something
    bio <- tibble(
      eliteID = api_json[["data"]][["id"]],
      name = api_json[["data"]][["name"]],
      pos = api_json[["data"]][["position"]],
      shoots = api_json[["data"]][["shoots"]],
      dob = as.Date(api_json[["data"]][["dateOfBirth"]]),
      height = api_json[["data"]][["height"]][["imperial"]],
      weight = api_json[["data"]][["weight"]][["imperial"]]
    )


    df_prospects <- bio %>%
      left_join(stats, by = "eliteID")

    prospects_stats <- bind_rows(prospects_stats, df_prospects)

    setTxtProgressBar(pb, i)


  }


  prospects_bio <- prospects_stats %>%
    select(name, dob, height, weight, pos, shoots) %>%
    distinct()

  prospects_stats <- prospects_stats %>%
    select(eliteID, eliteLink, name, teamName, leagueName,
           season, GP, G, A, PTS, PPG, PIMS) %>%
    rename(
      Team = "teamName",
      League = "leagueName",
      Season = "season"
    )

  return(prospects_stats)


}

#Created by Noah Cornish
