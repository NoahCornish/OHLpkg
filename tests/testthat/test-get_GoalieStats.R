test_that("get_GoalieStats returns expected columns", {

  goalies <- get_GoalieStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(goalies, "data.frame")

  expect_true(
    all(
      c(
        "Name",
        "Height",
        "Weight",
        "Team",
        "Birthdate",
        "GP",
        "SAV",
        "SH",
        "SAV%",
        "SH%",
        "GA",
        "GAA",
        "SO",
        "W",
        "L",
        "OTL",
        "TL",
        "SOGP",
        "SOW",
        "SOL",
        "PIM"
      ) %in% names(goalies)
    )
  )
})


test_that("get_GoalieStats returns correctly formatted data", {

  goalies <- get_GoalieStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(goalies$Birthdate, "Date")

  expect_true(
    is.numeric(goalies$GP)
  )

  expect_true(
    is.numeric(goalies$GAA)
  )

  expect_true(
    is.numeric(goalies$`SAV%`)
  )
})


test_that("get_GoalieStats respects minimum games filter", {

  goalies <- get_GoalieStats(
    season_name = "2027 Season",
    min_games = 5
  )

  expect_true(
    all(goalies$GP >= 5)
  )
})


test_that("get_GoalieStats team filter works", {

  goalies <- get_GoalieStats(
    season_name = "2027 Season",
    team = "London Knights",
    min_games = 0
  )

  expect_true(
    all(goalies$Team == "London Knights")
  )
})


test_that("get_GoalieStats supports multiple team filters", {

  teams <- c(
    "London Knights",
    "Erie Otters"
  )

  goalies <- get_GoalieStats(
    season_name = "2027 Season",
    team = teams,
    min_games = 0
  )

  expect_true(
    all(goalies$Team %in% teams)
  )
})


test_that("get_GoalieStats rejects invalid team values", {

  expect_error(
    get_GoalieStats(
      season_name = "2027 Season",
      team = 123,
      min_games = 0
    ),
    "`team` must be NULL or a character vector of team names.",
    fixed = TRUE
  )
})


test_that("get_GoalieStats rejects invalid min_games values", {

  expect_error(
    get_GoalieStats(
      season_name = "2027 Season",
      min_games = -1
    ),
    "`min_games` must be one non-negative numeric value.",
    fixed = TRUE
  )

  expect_error(
    get_GoalieStats(
      season_name = "2027 Season",
      min_games = NA
    )
  )

  expect_error(
    get_GoalieStats(
      season_name = "2027 Season",
      min_games = "10"
    )
  )
})
