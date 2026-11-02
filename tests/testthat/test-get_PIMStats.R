test_that("get_PIMStats returns expected columns", {

  pim <- get_PIMStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expect_s3_class(
    pim,
    "data.frame"
  )

  expect_named(
    pim,
    c(
      "Name",
      "BD",
      "Pos",
      "Team",
      "GP",
      "PIM",
      "PIM/G"
    )
  )
})


test_that("get_PIMStats calculates penalty minutes per game correctly", {

  pim <- get_PIMStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expected <- ifelse(
    pim$GP > 0,
    round(pim$PIM / pim$GP, 2),
    NA_real_
  )

  expect_equal(
    pim$`PIM/G`,
    expected
  )
})


test_that("get_PIMStats respects minimum games filter", {

  pim <- get_PIMStats(
    season_name = "2027 Season",
    min_games = 10
  )

  expect_true(
    all(pim$GP >= 10)
  )
})


test_that("get_PIMStats team filter works", {

  pim <- get_PIMStats(
    season_name = "2027 Season",
    team = "London Knights",
    min_games = 0
  )

  expect_true(
    all(pim$Team == "London Knights")
  )
})


test_that("get_PIMStats supports multiple team filters", {

  teams <- c(
    "London Knights",
    "Erie Otters"
  )

  pim <- get_PIMStats(
    season_name = "2027 Season",
    team = teams,
    min_games = 0
  )

  expect_true(
    all(pim$Team %in% teams)
  )
})


test_that("get_PIMStats is sorted by PIM and PIM per game", {

  pim <- get_PIMStats(
    season_name = "2027 Season",
    min_games = 0
  )

  expected <- pim[
    order(
      -pim$PIM,
      -pim$`PIM/G`,
      pim$Name,
      na.last = TRUE
    ),
    ,
    drop = FALSE
  ]

  rownames(expected) <- NULL

  expect_equal(
    pim,
    expected
  )
})
