test_that("get_Seasons returns expected columns", {

  seasons <- get_Seasons()

  expect_s3_class(
    seasons,
    "data.frame"
  )

  expect_named(
    seasons,
    c(
      "Season",
      "SeasonID",
      "SeasonType"
    )
  )
})


test_that("get_Seasons returns supported seasons", {

  seasons <- get_Seasons()

  expect_true(
    nrow(seasons) > 0
  )

  expect_false(
    any(is.na(seasons$Season))
  )

  expect_false(
    any(is.na(seasons$SeasonID))
  )

  expect_false(
    any(is.na(seasons$SeasonType))
  )
})


test_that("get_Seasons returns unique season names and IDs", {

  seasons <- get_Seasons()

  expect_equal(
    length(unique(seasons$Season)),
    nrow(seasons)
  )

  expect_equal(
    length(unique(seasons$SeasonID)),
    nrow(seasons)
  )
})


test_that("get_Seasons returns valid season types", {

  seasons <- get_Seasons()

  expect_true(
    all(
      seasons$SeasonType %in%
        c(
          "Regular Season",
          "Playoffs",
          "Pre-Season"
        )
    )
  )
})


test_that("get_Seasons contains current season mapping", {

  seasons <- get_Seasons()

  current <- seasons[
    seasons$Season == "2027 Season",
    ,
    drop = FALSE
  ]

  expect_equal(
    nrow(current),
    1
  )

  expect_equal(
    current$SeasonID,
    88L
  )

  expect_equal(
    current$SeasonType,
    "Regular Season"
  )
})


test_that("get_Seasons identifies playoff seasons correctly", {

  seasons <- get_Seasons()

  playoffs <- seasons[
    grepl("Playoffs", seasons$Season),
    ,
    drop = FALSE
  ]

  expect_true(
    all(playoffs$SeasonType == "Playoffs")
  )
})


test_that("get_Seasons identifies pre-season correctly", {

  seasons <- get_Seasons()

  preseason <- seasons[
    grepl("Pre-Season", seasons$Season),
    ,
    drop = FALSE
  ]

  expect_true(
    all(preseason$SeasonType == "Pre-Season")
  )
})


test_that(".get_season_id returns correct season IDs", {

  expect_equal(
    OHLpkg:::.get_season_id(
      "2027 Season"
    ),
    88
  )

  expect_equal(
    OHLpkg:::.get_season_id(
      "2026 Playoffs"
    ),
    85
  )

  expect_equal(
    OHLpkg:::.get_season_id(
      "2015 Season"
    ),
    51
  )
})


test_that(".get_season_id rejects invalid season names", {

  expect_error(
    OHLpkg:::.get_season_id(
      "2099 Season"
    ),
    "Unknown season_name",
    fixed = TRUE
  )

  expect_error(
    OHLpkg:::.get_season_id(
      NA_character_
    ),
    "`season_name` must be one non-missing character value.",
    fixed = TRUE
  )

  expect_error(
    OHLpkg:::.get_season_id(
      2027
    )
  )

  expect_error(
    OHLpkg:::.get_season_id(
      c(
        "2027 Season",
        "2026 Season"
      )
    )
  )
})
