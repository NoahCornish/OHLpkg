test_that("get_PlayerInfo returns expected columns", {

  info <- get_PlayerInfo(
    season_name = "2027 Season"
  )

  expect_s3_class(
    info,
    "data.frame"
  )

  expect_true(
    all(
      c(
        "player_id",
        "name",
        "height",
        "weight",
        "birthdate",
        "team_name",
        "team_id"
      ) %in% names(info)
    )
  )
})


test_that("get_PlayerInfo formats player data correctly", {

  info <- get_PlayerInfo(
    season_name = "2027 Season"
  )

  expect_true(
    is.numeric(info$player_id)
  )

  expect_true(
    is.numeric(info$weight)
  )

  expect_true(
    is.numeric(info$team_id)
  )

  expect_s3_class(
    info$birthdate,
    "Date"
  )
})


test_that("get_PlayerInfo team filter works", {

  info <- get_PlayerInfo(
    season_name = "2027 Season",
    team = "London Knights"
  )

  expect_true(
    all(info$team_name == "London Knights")
  )
})


test_that("get_PlayerInfo supports multiple team filters", {

  teams <- c(
    "London Knights",
    "Erie Otters"
  )

  info <- get_PlayerInfo(
    season_name = "2027 Season",
    team = teams
  )

  expect_true(
    all(info$team_name %in% teams)
  )
})


test_that("get_PlayerInfo rejects invalid team values", {

  expect_error(
    get_PlayerInfo(
      season_name = "2027 Season",
      team = 123
    ),
    "`team` must be NULL or a character vector of team names.",
    fixed = TRUE
  )
})


test_that("get_PlayerInfo is sorted by team and player name", {

  info <- get_PlayerInfo(
    season_name = "2027 Season"
  )

  expected <- info[
    order(
      info$team_name,
      info$name,
      na.last = TRUE
    ),
    ,
    drop = FALSE
  ]

  rownames(expected) <- NULL

  expect_equal(
    info,
    expected
  )
})
