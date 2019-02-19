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
  response <- ghr_get("r-lib/usethis")
  expect_true(all(c("name", "html_url") %in% ghr_fields(response)))
})

context("ghr_pull")

test_that("ghr_pull pulls the expected fields", {
  skip_if_net_down()
  response <- ghr_get("r-lib/usethis")

  filenames <- ghr_pull(response, "name")
  expect_true(all(c("DESCRIPTION", "NAMESPACE") %in% filenames))

  expect_true(
    "tests/testthat" %in% ghr_pull(ghr_get("r-lib/usethis/tests"), "path")
  )

  expect_true(
    all(
      grepl(
        "^https://github.com",
        ghr_pull(ghr_get("r-lib/usethis"), "html_url")
      )
    )
  )

  expect_true(
    all(
      grepl(
        "^https://raw.githubusercontent",
        ghr_pull(ghr_get("r-lib/usethis/R"), "download_url")
      )
    )
  )
})
