context("gh_expand_home")

test_that("gh_expand_home works with paths of 1, 2, 3, and 4 pieces", {
  expect_equal(gh_expand_home("x"), "https://github.com/x")
  expect_equal(gh_expand_home("x/y"), "https://github.com/x/y")
  expect_equal(gh_expand_home("x/y/z"), "https://github.com/x/y/blob/master/z")
  expect_equal(
    gh_expand_home("x/y/z", branch = "dev"),
    "https://github.com/x/y/blob/dev/z"
  )
})
