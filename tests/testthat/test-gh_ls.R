context("gh_call")

test_that("gh_call with pathts of different length creates the expected call", {
  expect_equal(gh_call("O"), "/users/o/repos")
  expect_equal(gh_call("O/R"), "/users/o/r/repos")
  expect_equal(gh_call("O/R/s1"), "/repos/o/r/contents/s1")
  expect_equal(gh_call("O/R/S1/S2"), "/repos/o/r/contents/s1/s2")
})
