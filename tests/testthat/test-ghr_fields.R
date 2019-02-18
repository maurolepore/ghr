context("ghr_fields")

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

test_that("ghr_fields and friends retun expected fields", {
  skip_if_net_down()
  gh_response <- gh_get("r-lib/usethis")
  expect_true(all(c("name", "html_url") %in% ghr_fields(gh_response)))

  filenames <- ghr_pull(gh_response, "name")
  expect_true(all(c("DESCRIPTION", "NAMESPACE") %in% filenames))

  expect_true("tests/testthat" %in% ghr_path(gh_get("r-lib/usethis/tests")))

  expect_true(
    all(grepl("^https://github.com", ghr_html_url(gh_get("r-lib/usethis"))))
  )
  expect_true(
    all(
      grepl("^https://raw.githubusercontent",
        ghr_download_url(gh_get("r-lib/usethis/R")))
    )
  )
})

test_that("ghr_download_url errs with informative message", {
  skip_if_net_down()
  expect_error(
    ghr_download_url(gh_get("r-lib")), "nothing to download"
  )
})

#' # Shortcuts
#' ghr_path(gh_response)
#' ghr_download_url(gh_response)
#'
#' # Working with non-default branches
#' ghr_path(gh_get("r-lib/usethis", ref = "gh-pages"))
#' # Same
#' ghr_path(gh_get("r-lib/usethis@gh-pages"))
#' ghr_path(gh_get("r-lib/usethis/news@gh-pages"))
