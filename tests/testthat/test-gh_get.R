context("gh_get")

has_internet <- function() {
  z <- try(suppressWarnings(readLines('https://www.google.com', n = 1)),
    silent = TRUE)
  !inherits(z, "try-error")
}

skip_if_net_down <- function() {
  if (has_internet()) {
    return()
  }
  testthat::skip("no internet")
}

test_that("gh_get outputs the expected list object", {
 skip_if_net_down()
 out <- gh_get("r-lib")
 expect_is(out, "gh_response")
 expect_is(out, "list")
})

test_that("gh_get is memoised", {
 skip_if_net_down()
 first_call <- system.time(gh_get("r-lib/usethis"))
 second_call <- system.time(gh_get("r-lib/usethis"))
 expect_true(first_call[[3]] > second_call[[3]])
})

test_that("gh_get works with syntax owner/repo@branch", {
 skip_if_net_down()
 expect_is(gh_get("r-lib/usethis", ref = "gh-pages"), "gh_response")
 expect_is(gh_get("r-lib/usethis@gh-pages"), "gh_response")

 expect_is(gh_get("r-lib/usethis/news", ref = "gh-pages"), "gh_response")
 expect_is(gh_get("r-lib/usethis/news@gh-pages"), "gh_response")
})

test_that("gh_get with bad `ref` (branch) errs with informative message", {
  expect_error(gh_get("r-lib/usethis@badbranch"), "404 Not Found")
  expect_error(
    gh_get("r-lib@badbranch"), "`ref`.*makes no sense.* forget.*repo"
  )
  expect_error(
    gh_get("r-lib", ref = "badbranch"), "`ref`.*makes no sense.* forget.*repo"
  )
})

context("gh_branches")

test_that("gh_branches outputs expected branches", {
  skip_if_net_down()
  expect_true(all(c("master", "gh-pages") %in% gh_branches("r-lib/usethis")))
})
