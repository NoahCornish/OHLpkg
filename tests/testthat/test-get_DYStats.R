test_that("get_DYStats returns expected columns", {

  dy <- get_DYStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(dy, "data.frame")

  expect_true(
    all(
      c(
        "Name",
        "Rookie",
        "BD",
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
        "GWG",
        "ENG",
        "PIM"
      ) %in% names(dy)
    )
  )
})


test_that("get_DYStats returns only draft-eligible birthdates", {

  dy <- get_DYStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_true(
    all(
      dy$BD >= as.Date("2008-09-16") &
        dy$BD <= as.Date("2009-09-15")
    )
  )
})


test_that("get_DYStats respects minimum games filter", {

  dy <- get_DYStats(
    season_name = "2027 Season",
    min_games = 10
  )

  expect_true(
    all(dy$GP >= 10)
  )
})


test_that("get_DYStats team filter works", {

  dy <- get_DYStats(
    season_name = "2027 Season",
    team = "London Knights",
    min_games = 0
  )

  expect_true(
    all(dy$Team == "London Knights")
  )
})
