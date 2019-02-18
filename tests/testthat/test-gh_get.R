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
 out <- gh_get("r-lib/usethis")
 expect_is(out, "gh_response")
 expect_is(out, "list")
})

test_that("gh_get is memoised", {
 skip_if_net_down()
 first_call <- system.time(gh_get("r-lib/usethis"))
 second_call <- system.time(gh_get("r-lib/usethis"))
 expect_true(first_call[[3]] > second_call[[3]])

})

#
# # The request to GitHub happens only the first time you call gh_get()
# system.time(gh_get("r-lib/usethis/R"))
# # Later calls take no time because the first call is memoised
# system.time(gh_get("r-lib/usethis/R"))
#
# ghr_path(gh_get("r-lib/usethis", ref = "gh-pages"))
# # Same
# ghr_path(gh_get("r-lib/usethis@gh-pages"))
# ghr_path(gh_get("r-lib/usethis/news@gh-pages"))





context("gh_path")

test_that("gh_path with pathts of different length creates the expected call", {
  expect_equal(gh_path("O"), "/users/O/repos")
  expect_equal(gh_path("O/R"), "/repos/O/R/contents")
  expect_equal(gh_path("O/R/s1"), "/repos/O/R/contents/s1")
  expect_equal(gh_path("O/R/S1/S2"), "/repos/O/R/contents/S1/S2")
})
