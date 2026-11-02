test_that("get_DraftData validates arguments", {

  expect_error(
    get_DraftData(player_id = "invalid"),
    "player_id"
  )

  expect_error(
    get_DraftData(player_id = 9118, pause = -1),
    "pause"
  )

  expect_error(
    get_DraftData(player_id = 9118, team = 123),
    "team"
  )

})
