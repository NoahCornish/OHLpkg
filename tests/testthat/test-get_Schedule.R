test_that("get_GameEvents returns a data frame for a valid game", {

  schedule <- get_Schedule()

  expect_true(
    nrow(schedule) > 0
  )

  game_id <- schedule$ID[1]

  events <- suppressWarnings(
    get_GameEvents(game_id)
  )

  expect_s3_class(
    events,
    "data.frame"
  )
})


test_that("get_GameEvents accepts numeric and character game IDs", {

  schedule <- get_Schedule()

  game_id_numeric <- schedule$ID[1]

  game_id_character <- as.character(
    game_id_numeric
  )

  numeric_events <- suppressWarnings(
    get_GameEvents(
      game_id_numeric
    )
  )

  character_events <- suppressWarnings(
    get_GameEvents(
      game_id_character
    )
  )

  expect_s3_class(
    numeric_events,
    "data.frame"
  )

  expect_s3_class(
    character_events,
    "data.frame"
  )
})


test_that("get_GameEvents rejects invalid game IDs", {

  expect_error(
    get_GameEvents(0),
    "`game_id` must be one positive whole-number game ID.",
    fixed = TRUE
  )

  expect_error(
    get_GameEvents(-1)
  )

  expect_error(
    get_GameEvents(1.5)
  )

  expect_error(
    get_GameEvents("abc")
  )

  expect_error(
    get_GameEvents("")
  )

  expect_error(
    get_GameEvents(c(1, 2))
  )

  expect_error(
    get_GameEvents(NA)
  )
})


test_that("get_GameEvents removes inherited row names", {

  schedule <- get_Schedule()

  game_id <- schedule$ID[1]

  events <- suppressWarnings(
    get_GameEvents(game_id)
  )

  if (nrow(events) > 0) {

    expect_equal(
      rownames(events),
      as.character(
        seq_len(nrow(events))
      )
    )
  }
})
