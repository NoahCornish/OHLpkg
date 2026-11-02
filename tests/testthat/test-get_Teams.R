test_that("get_Teams returns expected columns", {

  teams <- get_Teams()

  expect_s3_class(
    teams,
    "data.frame"
  )

  expect_named(
    teams,
    "Team"
  )
})


test_that("get_Teams returns unique team names", {

  teams <- get_Teams()

  expect_equal(
    length(unique(teams$Team)),
    nrow(teams)
  )

  expect_false(
    any(is.na(teams$Team))
  )

  expect_true(
    all(nzchar(teams$Team))
  )
})


test_that("get_Teams returns teams alphabetically", {

  teams <- get_Teams()

  expect_equal(
    teams$Team,
    sort(teams$Team)
  )
})


test_that("get_Teams team filter works", {

  teams <- get_Teams(
    team = "London Knights"
  )

  expect_equal(
    teams$Team,
    "London Knights"
  )
})


test_that("get_Teams supports multiple team filters", {

  requested_teams <- c(
    "London Knights",
    "Erie Otters"
  )

  teams <- get_Teams(
    team = requested_teams
  )

  expect_true(
    all(teams$Team %in% requested_teams)
  )

  expect_equal(
    sort(teams$Team),
    sort(requested_teams)
  )
})


test_that("get_Teams works with another supported season", {

  teams <- get_Teams(
    season_name = "2026 Season"
  )

  expect_s3_class(
    teams,
    "data.frame"
  )

  expect_named(
    teams,
    "Team"
  )

  expect_true(
    nrow(teams) > 0
  )
})


test_that("get_Teams rejects invalid team values", {

  expect_error(
    get_Teams(
      team = 123
    ),
    "`team` must be NULL or a character vector of team names.",
    fixed = TRUE
  )
})
