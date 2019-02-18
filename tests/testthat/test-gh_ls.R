context("gh_path")

test_that("gh_path with pathts of different length creates the expected call", {
  expect_equal(gh_path("O"), "/users/O/repos")
  expect_equal(gh_path("O/R"), "/repos/O/R/contents")
  expect_equal(gh_path("O/R/s1"), "/repos/O/R/contents/s1")
  expect_equal(gh_path("O/R/S1/S2"), "/repos/O/R/contents/S1/S2")
})
