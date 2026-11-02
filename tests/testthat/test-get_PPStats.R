test_that("get_PPStats returns expected columns", {

  pp <- get_PPStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(pp, "data.frame")

  expect_true(
    all(
      c(
        "Name",
        "BD",
        "Pos",
        "Team",
        "GP",
        "PPG",
        "PPA",
        "PPP",
        "PPP/G",
        "PPP%"
      ) %in% names(pp)
    )
  )
})


test_that("get_PPStats calculates power-play points correctly", {

  pp <- get_PPStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_equal(
    pp$PPP,
    pp$PPG + pp$PPA
  )
})


test_that("get_PPStats respects minimum games filter", {

  pp <- get_PPStats(
    season_name = "2027 Season",
    min_games = 10
  )

  expect_true(
    all(pp$GP >= 10)
  )
})


test_that("get_PPStats team filter works", {

  pp <- get_PPStats(
    season_name = "2027 Season",
    team = "London Knights",
    min_games = 0
  )

  expect_true(
    all(pp$Team == "London Knights")
  )
})
