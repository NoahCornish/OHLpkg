# Version 2.5.0
# get_GameEvents.R
# Created by: Noah Cornish
# Description: Get play-by-play events for a specific game.

#' Get game events
#'
#' @description Retrieves game event data (play-by-play) for a given game.
#' @param game_id Numeric. The unique game ID.
#' @return A data frame with play-by-play events.
#' @examples
#' events <- get_GameEvents(game_id = 12345)
#' head(events)
#' @export
get_GameEvents <- function(game_id) {
  library(httr)
  library(jsonlite)
  library(dplyr)
  library(tibble)

  # Construct the URL dynamically using the game_id argument
  url <- paste0(
    "https://lscluster.hockeytech.com/feed/?feed=gc&key=f1aa699db3d81487&game_id=",
    game_id,
    "&client_code=ohl&tab=pxpverbose&lang_code=en&fmt=json&callback=jsonp_1723423538948_88654"
  )

  # Send a GET request to retrieve the content
  response <- GET(url)
  content_raw <- content(response, "text")

  # Use regex to clean the JSONP wrapper and extract the JSON content
  content_clean <- sub("^[^(]*\\(", "", content_raw)
  content_clean <- sub("\\);?$", "", content_clean)

  # Parse the cleaned JSON content
  json_data <- fromJSON(content_clean)

  # Convert the relevant data to a tibble for easier manipulation
  events <- as_tibble(json_data[["GC"]][["Pxpverbose"]])

  return(events)
}
