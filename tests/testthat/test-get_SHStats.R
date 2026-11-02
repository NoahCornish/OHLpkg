test_that("get_SHStats returns expected columns", {

  sh <- get_SHStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(sh, "data.frame")

  expect_true(
    all(
      c(
        "Name",
        "BD",
        "Pos",
        "Team",
        "GP",
        "SHG",
        "SHA",
        "SHPTS",
        "SHPTS/G",
        "SHPTS%"
      ) %in% names(sh)
    )
  )
})


test_that("get_SHStats calculates short-handed points correctly", {

  sh <- get_SHStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_equal(
    sh$SHPTS,
    sh$SHG + sh$SHA
  )
})


test_that("get_SHStats respects minimum games filter", {

  sh <- get_SHStats(
    season_name = "2027 Season",
    min_games = 10
  )

  expect_true(
    all(sh$GP >= 10)
  )
})


test_that("get_SHStats team filter works", {

  sh <- get_SHStats(
    season_name = "2027 Season",
    team = "London Knights",
    min_games = 0
  )

  expect_true(
    all(sh$Team == "London Knights")
  )
})
