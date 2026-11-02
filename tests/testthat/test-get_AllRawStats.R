test_that("get_AllRawStats retrieves all raw columns", {

  raw <- get_AllRawStats("2027 Season")

  expect_s3_class(raw, "data.frame")
  expect_gt(nrow(raw), 0)
  expect_true("player_id" %in% names(raw))
  expect_true("faceoff_wins" %in% names(raw))
  expect_true("assists" %in% names(raw))

})
