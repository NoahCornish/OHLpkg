# Version 2.6.0
# get_GameEvents.R
# Created by: Noah Cornish
# Description: Retrieve play-by-play events for a specific OHL game.

#' Get OHL Game Events
#'
#' @description
#' Retrieves detailed play-by-play event data for a specific OHL game.
#' Game IDs can be obtained from the \code{ID} column returned by
#' \code{get_Schedule()}.
#'
#' @param game_id Numeric or character. The unique OHL game ID.
#'
#' @return A data frame containing available play-by-play events.
#'
#' @examples
#' \dontrun{
#' schedule <- get_Schedule()
#'
#' game_events <- get_GameEvents(
#'   game_id = schedule$ID[1]
#' )
#'
#' head(game_events)
#' }
#'
#' @export
get_GameEvents <- function(game_id) {

  # Validate the game ID
  if (
    length(game_id) != 1L ||
    is.na(game_id) ||
    (!is.numeric(game_id) && !is.character(game_id))
  ) {
    stop(
      "`game_id` must be one positive numeric or character game ID.",
      call. = FALSE
    )
  }

  if (is.numeric(game_id)) {

    if (
      !is.finite(game_id) ||
      game_id <= 0 ||
      game_id != floor(game_id)
    ) {
      stop(
        "`game_id` must be one positive whole-number game ID.",
        call. = FALSE
      )
    }

    game_id <- format(
      game_id,
      scientific = FALSE,
      trim = TRUE
    )

  } else {

    game_id <- trimws(game_id)

    if (!grepl("^[1-9][0-9]*$", game_id)) {
      stop(
        "`game_id` must contain only positive whole-number digits.",
        call. = FALSE
      )
    }
  }

  # Build the OHL game-centre API URL
  url <- paste0(
    "https://lscluster.hockeytech.com/feed/",
    "?feed=gc",
    "&key=f1aa699db3d81487",
    "&game_id=", game_id,
    "&client_code=ohl",
    "&tab=pxpverbose",
    "&lang_code=en",
    "&fmt=json"
  )

  # Retrieve and parse the play-by-play data
  json_data <- tryCatch(
    jsonlite::fromJSON(
      url,
      simplifyDataFrame = TRUE
    ),
    error = function(error) {
      stop(
        paste0(
          "OHL game events could not be retrieved for game ID ",
          game_id,
          ". ",
          error$message
        ),
        call. = FALSE
      )
    }
  )

  # Extract the play-by-play table
  events <- json_data[["GC"]][["Pxpverbose"]]

  # Return gracefully when no events are available
  if (!is.data.frame(events) || nrow(events) == 0L) {
    warning(
      paste0(
        "No play-by-play events are currently available for game ID ",
        game_id,
        "."
      ),
      call. = FALSE
    )

    return(data.frame())
  }

  # Remove inherited row numbers
  rownames(events) <- NULL

  return(events)
}
