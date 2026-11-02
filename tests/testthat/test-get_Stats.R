test_that("get_Stats returns a data frame", {

  stats <- get_Stats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(stats, "data.frame")
})


test_that("get_Stats returns expected core columns", {

  stats <- get_Stats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_true(
    all(
      c(
        "Name",
        "Team",
        "GP",
        "G",
        "A",
        "PTS",
        "Pts/G",
        "PPG",
        "PPA",
        "PPP",
        "SHG",
        "SHA",
        "SHPTS"
      ) %in% names(stats)
    )
  )
})


test_that("get_Stats respects minimum games filter", {

  stats <- get_Stats(
    season_name = "2027 Season",
    min_games = 10
  )

  expect_true(
    all(stats$GP >= 10)
  )
})


test_that("get_Stats team filter works", {

  stats <- get_Stats(
    season_name = "2027 Season",
    min_games = 0,
    team = "London Knights"
  )

  expect_true(
    all(stats$Team == "London Knights")
  )
})


test_that("get_Stats supports multiple team filters", {

  teams <- c(
    "London Knights",
    "Erie Otters"
  )

  stats <- get_Stats(
    season_name = "2027 Season",
    min_games = 0,
    team = teams
  )

  expect_true(
    all(stats$Team %in% teams)
  )
})


test_that("get_Stats rejects invalid min_games values", {

  expect_error(
    get_Stats(
      season_name = "2027 Season",
      min_games = -1
    ),
    "`min_games` must be one non-negative numeric value.",
    fixed = TRUE
  )

  expect_error(
    get_Stats(
      season_name = "2027 Season",
      min_games = NA
    )
  )

  expect_error(
    get_Stats(
      season_name = "2027 Season",
      min_games = "10"
    )
  )
})
