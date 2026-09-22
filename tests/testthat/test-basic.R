test_that("OHLpkg loads correctly", {
  expect_true("OHLpkg" %in% loadedNamespaces())
})

test_that("OHLpkg exports functions", {
  expect_gt(length(getNamespaceExports("OHLpkg")), 0)
})
