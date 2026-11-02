test_that("get_RKStats returns expected columns", {

  rookies <- get_RKStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(rookies, "data.frame")

  expect_true(
    all(
      c(
        "Name",
        "BD",
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
        "GWG",
        "ENG",
        "PIM"
      ) %in% names(rookies)
    )
  )
})


test_that("get_RKStats returns only rookies", {

  all_stats <- get_Stats(
    season_name = "2027 Season",
    min_games = 0
  )

  rookies <- get_RKStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expected_rookies <- all_stats[
    !is.na(all_stats$Rookie) &
      all_stats$Rookie == "YES",
    ,
    drop = FALSE
  ]

  expect_true(
    all(rookies$Name %in% expected_rookies$Name)
  )

  expect_equal(
    nrow(rookies),
    nrow(expected_rookies)
  )
})


test_that("get_RKStats respects minimum games filter", {

  rookies <- get_RKStats(
    season_name = "2027 Season",
    min_games = 10
  )

  expect_true(
    all(rookies$GP >= 10)
  )
})


test_that("get_RKStats team filter works", {

  rookies <- get_RKStats(
    season_name = "2027 Season",
    team = "London Knights",
    min_games = 0
  )

  expect_true(
    all(rookies$Team == "London Knights")
  )
})


test_that("get_RKStats supports multiple team filters", {

  teams <- c(
    "London Knights",
    "Erie Otters"
  )

  rookies <- get_RKStats(
    season_name = "2027 Season",
    team = teams,
    min_games = 0
  )

  expect_true(
    all(rookies$Team %in% teams)
  )
})


test_that("get_RKStats is sorted by points, goals, and name", {

  rookies <- get_RKStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expected <- rookies[
    order(
      -rookies$PTS,
      -rookies$G,
      rookies$Name,
      na.last = TRUE
    ),
    ,
    drop = FALSE
  ]

  rownames(expected) <- NULL

  expect_equal(
    rookies,
    expected
  )
})
