test_that("get_RawStats returns expected columns", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expect_s3_class(raw, "data.frame")

  expect_true(
    all(
      c(
        "Name",
        "Rookie",
        "JN",
        "BD",
        "BD_Y",
        "Hgt",
        "Wgt",
        "Pos",
        "Team",
        "GP",
        "G",
        "A",
        "PTS",
        "Pts/G",
        "+/-",
        "PPG",
        "PPA",
        "PPP",
        "SHG",
        "SHA",
        "SHPTS",
        "GWG",
        "ENG",
        "PIM",
        "Active"
      ) %in% names(raw)
    )
  )
})


test_that("get_RawStats formats player data correctly", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expect_s3_class(raw$BD, "Date")

  expect_true(
    is.numeric(raw$GP)
  )

  expect_true(
    is.numeric(raw$PTS)
  )

  expect_true(
    is.numeric(raw$PPG)
  )

  expect_true(
    is.numeric(raw$PPA)
  )

  expect_true(
    is.numeric(raw$PPP)
  )
})


test_that("get_RawStats calculates birth year correctly", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expected_birth_year <- as.integer(
    format(raw$BD, "%Y")
  )

  expect_equal(
    raw$BD_Y,
    expected_birth_year
  )
})


test_that("get_RawStats calculates power-play points correctly", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expect_equal(
    raw$PPP,
    raw$PPG + raw$PPA
  )
})


test_that("get_RawStats converts rookie indicator correctly", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expect_true(
    all(raw$Rookie %in% c("YES", "NO"))
  )
})


test_that("get_RawStats contains only active skaters", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expect_true(
    all(raw$Active == 1)
  )

  expect_false(
    any(raw$Pos == "G")
  )
})


test_that("get_RawStats team filter works", {

  raw <- get_RawStats(
    season_name = "2027 Season",
    team = "London Knights"
  )

  expect_true(
    all(raw$Team == "London Knights")
  )
})


test_that("get_RawStats supports multiple team filters", {

  teams <- c(
    "London Knights",
    "Erie Otters"
  )

  raw <- get_RawStats(
    season_name = "2027 Season",
    team = teams
  )

  expect_true(
    all(raw$Team %in% teams)
  )
})


test_that("get_RawStats rejects invalid team values", {

  expect_error(
    get_RawStats(
      season_name = "2027 Season",
      team = 123
    ),
    "`team` must be NULL or a character vector of team names.",
    fixed = TRUE
  )
})


test_that("get_RawStats removes inherited row names", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expect_equal(
    rownames(raw),
    as.character(seq_len(nrow(raw)))
  )
})

test_that("get_RawStats returns valid player IDs", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expect_true(
    is.numeric(raw$PlayerID)
  )

  expect_false(
    any(is.na(raw$PlayerID))
  )

  expect_true(
    all(raw$PlayerID > 0)
  )
})


test_that("get_RawStats builds player photo URLs correctly", {

  raw <- get_RawStats(
    season_name = "2027 Season"
  )

  expected_urls <- paste0(
    "https://assets.leaguestat.com/ohl/240x240/",
    raw$PlayerID,
    ".jpg"
  )

  expect_equal(
    raw$PhotoURL,
    expected_urls
  )

  expect_true(
    all(grepl(
      "^https://assets\\.leaguestat\\.com/ohl/240x240/[0-9]+\\.jpg$",
      raw$PhotoURL
    ))
  )
})
