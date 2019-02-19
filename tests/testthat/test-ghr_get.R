context("ghr_get")

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

test_that("ghr_get outputs the expected list object", {
 skip_if_net_down()
 out <- ghr_get("maurolepore")
 expect_is(out, "gh_response")
 expect_is(out, "list")
})

test_that("ghr_get is memoised", {
 skip("FIXME: Inconsistent")
 first_call <- system.time(ghr_get("maurolepore/ghr/"))
 second_call <- system.time(ghr_get("maurolepore/ghr/"))
 expect_true(first_call[[3]] > second_call[[3]])
})

test_that("ghr_get understands the syntax owner/repo@branch", {
 skip_if_net_down()
 expect_is(ghr_get("maurolepore/ghr/", ref = "gh-pages"), "gh_response")
 expect_is(ghr_get("maurolepore/ghr/@gh-pages"), "gh_response")

 expect_is(ghr_get("maurolepore/ghr/reference", ref = "gh-pages"), "gh_response")
 expect_is(ghr_get("maurolepore/ghr/reference@gh-pages"), "gh_response")
})

test_that("ghr_get with bad `ref` (branch) errs with informative message", {
  skip_if_net_down()
  expect_error(ghr_get("maurolepore/ghr/@badbranch"), "404 Not Found")
  expect_error(
    ghr_get("maurolepore@badbranch"), "`ref`.*makes no sense.* forget.*repo"
  )
  expect_error(
    ghr_get("maurolepore", ref = "badbranch"),
    "`ref`.*makes no sense.* forget.*repo"
  )
})

context("ghr_branches")

test_that("ghr_branches outputs expected branches", {
  skip_if_net_down()
  expect_true(
    all(c("master", "gh-pages") %in% ghr_show_branches("maurolepore/ghr/"))
  )
})
