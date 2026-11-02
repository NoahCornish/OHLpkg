test_that("get_EVStats returns expected columns", {

  ev <- get_EVStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(ev, "data.frame")

  expect_true(
    all(
      c(
        "Name",
        "BD",
        "Pos",
        "Team",
        "GP",
        "EVG",
        "EVA",
        "EVPTS",
        "EVPTS/G",
        "EVPTS%"
      ) %in% names(ev)
    )
  )
})


test_that("get_EVStats calculates even-strength points correctly", {

  ev <- get_EVStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_equal(
    ev$EVPTS,
    ev$EVG + ev$EVA
  )
})


test_that("get_EVStats respects minimum games filter", {

  ev <- get_EVStats(
    season_name = "2027 Season",
    min_games = 10
  )

  expect_true(
    all(ev$GP >= 10)
  )
})


test_that("get_EVStats team filter works", {

  ev <- get_EVStats(
    season_name = "2027 Season",
    team = "London Knights",
    min_games = 0
  )

  expect_true(
    all(ev$Team == "London Knights")
  )
})
