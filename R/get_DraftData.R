# Version 2.7.0
# get_DraftData.R
# Created by: Noah Cornish
# Description: OHL Priority, U18, CHL Import, and NHL draft histories.

.ohl_draft_section <- function(page_text) {
  page_text <- gsub("[[:space:]\u00a0]+", " ", page_text, perl = TRUE)
  start <- regexpr("\\bDraft\\s*:", page_text, ignore.case = TRUE, perl = TRUE)
  if (start[1L] < 0L) return(NA_character_)
  section <- substr(page_text, start[1L] + attr(start, "match.length"), nchar(page_text))
  end <- regexpr("\\b(?:19|20)[0-9]{2}-[0-9]{2}\\s+(?:Regular Season|Playoffs|Preseason)\\b|\\bSeason Stats\\b|\\bGame by Game\\b", section, ignore.case = TRUE, perl = TRUE)
  if (end[1L] > 0L) section <- substr(section, 1L, end[1L] - 1L)
  trimws(section)
}

.ohl_draft_pattern <- paste0(
  "(OHL[[:space:]-]*U[[:space:]-]*18|U[[:space:]-]*18|UNDER[[:space:]-]*18|CHL[[:space:]-]*IMPORT|IMPORT|OHL|NHL)",
  "\\s*-\\s*([A-Z0-9.]+)\\s*(FA\\s*)?",
  "\\(\\s*([0-9]{4})\\s*\\)\\s*",
  "(?:Round|RD)\\s*:\\s*([0-9]*)\\s*",
  "\\(\\s*#\\s*([0-9]*)\\s*\\)"
)

.ohl_empty_draft_row <- function(id) {
  data.frame(
    PlayerID = as.integer(id), Name = NA_character_,
    DOB = as.Date(NA_character_), Pos = NA_character_,
    OHLDraftYear = NA_integer_, OHLDraftRound = NA_integer_,
    OHLDraftOverall = NA_integer_, OHLDraftTeam = NA_character_,
    OHLDraftStatus = NA_character_,
    OHLFARegistrationYear = NA_integer_, OHLFARegistrationTeam = NA_character_,
    U18DraftYear = NA_integer_, U18DraftRound = NA_integer_,
    U18DraftOverall = NA_integer_, U18DraftTeam = NA_character_,
    ImportDraftYear = NA_integer_, ImportDraftRound = NA_integer_,
    ImportDraftOverall = NA_integer_, ImportDraftTeam = NA_character_,
    NHLDraftYear = NA_integer_, NHLDraftRound = NA_integer_,
    NHLDraftOverall = NA_integer_, NHLDraftTeam = NA_character_,
    AcquisitionType = NA_character_, FreeAgent = NA,
    ProfileStatus = "Fetch failed", DraftRaw = NA_character_,
    ProfileURL = paste0("https://chl.ca/ohl/players/", id, "/"),
    stringsAsFactors = FALSE
  )
}

.ohl_parse_draft_text <- function(out, page_text) {
  section <- .ohl_draft_section(page_text)
  if (is.na(section)) {
    out$ProfileStatus <- "Draft section missing"
    return(out)
  }
  out$DraftRaw <- section
  entries <- regmatches(section, gregexpr(.ohl_draft_pattern, section, perl = TRUE, ignore.case = TRUE))[[1L]]
  leftover <- trimws(gsub(.ohl_draft_pattern, "", section, perl = TRUE, ignore.case = TRUE))
  unknown <- nzchar(leftover) && !toupper(leftover) %in% c("NONE", "N/A", "NOT DRAFTED", "-")
  acquired <- character(0)
  explicit_fa <- FALSE

  for (entry in entries) {
    parts <- regmatches(entry, regexec(.ohl_draft_pattern, entry, perl = TRUE, ignore.case = TRUE))[[1L]]
    if (length(parts) != 7L) next
    label <- toupper(gsub("[[:space:]-]", "", parts[2L]))
    category <- if (label == "NHL") "NHL" else if (label %in% c("IMPORT", "CHLIMPORT")) "Import" else if (label %in% c("U18", "OHLU18", "UNDER18")) "U18" else "OHL"
    team <- parts[3L]
    is_fa <- nzchar(trimws(parts[4L]))
    year <- as.integer(parts[5L])
    round <- if (nzchar(parts[6L])) as.integer(parts[6L]) else NA_integer_
    overall <- if (nzchar(parts[7L])) as.integer(parts[7L]) else NA_integer_
    if (category == "OHL" && is_fa) {
      explicit_fa <- TRUE
      out$OHLDraftStatus <- "Free Agent"
      out$OHLFARegistrationYear <- year
      out$OHLFARegistrationTeam <- team
      next
    }
    if (is_fa) { unknown <- TRUE; next }
    prefix <- paste0(category, "Draft")
    if (is.na(out[[paste0(prefix, "Year")]])) {
      out[[paste0(prefix, "Year")]] <- year
      out[[paste0(prefix, "Round")]] <- round
      out[[paste0(prefix, "Overall")]] <- overall
      out[[paste0(prefix, "Team")]] <- team
    }
    if (category == "OHL") out$OHLDraftStatus <- "Drafted"
    if (category != "NHL") acquired <- c(acquired, category)
  }
  if (length(acquired)) {
    out$FreeAgent <- FALSE
    out$AcquisitionType <- switch(acquired[1L], OHL = "OHL Priority Selection", U18 = "OHL U18 Priority Selection", Import = "CHL Import Draft")
  } else if (!unknown && (explicit_fa || toupper(section) %in% c("NONE", "N/A", "NOT DRAFTED", "-"))) {
    out$FreeAgent <- TRUE
    out$AcquisitionType <- "Free Agent"
  }
  out$ProfileStatus <- if (unknown) "Unrecognized draft text" else "OK"
  out
}

#' Get OHL Player Draft Data
#'
#' @description
#' Retrieves OHL Priority, U18, CHL Import and NHL draft information from
#' official OHL player profiles. Season and team searches obtain player IDs
#' exclusively from \code{get_AllRawStats()}. NHL draft status does not
#' determine OHL free-agent status. Ambiguous records remain \code{NA}.
#'
#' @param player_id Optional vector of numeric OHL player IDs. If supplied,
#'   \code{team} and season arguments are not used.
#' @param season_name Season name for team or season searches; defaults to
#'   \code{"2027 Season"}.
#' @param team Optional character vector of OHL team names.
#' @param pause Non-negative seconds between player-profile requests.
#' @param csv_file Optional output CSV filename.
#' @return Data frame with player details, draft histories, acquisition
#'   classification, profile status and source URL.
#' @examples
#' \dontrun{
#' get_DraftData(player_id = 9118)
#' get_DraftData(season_name = "2027 Season", team = "Peterborough Petes")
#' get_DraftData(season_name = "2027 Season", csv_file = "OHL_DraftData.csv")
#' }
#' @export
get_DraftData <- function(player_id = NULL, season_name = "2027 Season",
                          team = NULL, pause = 0.3, csv_file = NULL) {
  if (!is.numeric(pause) || length(pause) != 1L || is.na(pause) || !is.finite(pause) || pause < 0)
    stop("`pause` must be a single non-negative number.", call. = FALSE)
  if (!is.null(csv_file) && (!is.character(csv_file) || length(csv_file) != 1L || is.na(csv_file) || !nzchar(csv_file)))
    stop("`csv_file` must be NULL or one filename.", call. = FALSE)
  if (!is.null(team) && (!is.character(team) || anyNA(team)))
    stop("`team` must be NULL or a character vector without NA values.", call. = FALSE)

  if (is.null(player_id)) {
    players <- get_AllRawStats(season_name = season_name, team = team)
    id_column <- intersect(c("player_id", "PlayerID"), names(players))
    if (!length(id_column)) stop("get_AllRawStats() did not return player IDs.", call. = FALSE)
    player_id <- players[[id_column[1L]]]
    if (length(player_id) < 25L && is.null(team))
      warning("Season feed returned fewer than 25 player IDs; check completeness.", call. = FALSE)
  } else if (!is.null(team)) {
    warning("`team` is ignored when `player_id` is supplied.", call. = FALSE)
  }

  ids <- unique(trimws(as.character(player_id)))
  ids <- ids[!is.na(ids) & nzchar(ids)]
  if (any(!grepl("^[0-9]+$", ids)))
    stop("`player_id` must contain numeric OHL player IDs.", call. = FALSE)

  fetch_one <- function(id) {
    out <- .ohl_empty_draft_row(id)
    doc <- tryCatch(rvest::read_html(out$ProfileURL), error = function(e) NULL)
    if (is.null(doc)) return(out)
    body <- rvest::html_element(doc, "body")
    if (inherits(body, "xml_missing")) return(out)
    txt <- rvest::html_text2(body)
    headings <- rvest::html_elements(doc, "h1")
    if (length(headings)) out$Name <- trimws(rvest::html_text2(headings[1L]))
    dob <- regmatches(txt, regexpr("(?i)Birthdate\\s*:\\s*[0-9]{4}-[0-9]{2}-[0-9]{2}", txt, perl = TRUE))
    if (length(dob) && nzchar(dob)) out$DOB <- as.Date(sub(".*:\\s*", "", dob, perl = TRUE))
    pos <- regmatches(txt, regexec("(?i)(?:#\\s*)?[0-9]{1,3}\\s*\\|\\s*(LW|RW|C|D|LD|RD|G)\\s*\\|", txt, perl = TRUE))[[1L]]
    if (length(pos) == 2L) out$Pos <- toupper(pos[2L])
    .ohl_parse_draft_text(out, txt)
  }

  results <- lapply(seq_along(ids), function(i) {
    if (i > 1L && pause > 0) Sys.sleep(pause)
    fetch_one(ids[i])
  })
  result <- if (length(results)) do.call(rbind, results) else .ohl_empty_draft_row(0)[FALSE, , drop = FALSE]
  rownames(result) <- NULL
  if (!is.null(csv_file)) utils::write.csv(result, csv_file, row.names = FALSE, na = "")
  result
}
