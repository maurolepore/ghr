context("ghr_show_fields")

source(test_path("skip_if_net_down.R"))

test_that("ghr_show_fields and friends retun expected fields", {
  skip_if_net_down()
  response <- ghr_get("maurolepore/ghr")
  expect_true(all(c("name", "html_url") %in% ghr_show_fields(response)))
})

context("ghr_pull")

test_that("ghr_pull pulls the expected fields", {
  skip_if_net_down()
  response <- ghr_get("maurolepore/ghr")

  filenames <- ghr_pull(response, "name")
  expect_true(all(c("DESCRIPTION", "NAMESPACE") %in% filenames))

  expect_true(
    "tests/testthat" %in% ghr_pull(ghr_get("maurolepore/ghr/tests"), "path")
  )

  expect_true(
    all(
      grepl(
        "^https://github.com",
        ghr_pull(ghr_get("maurolepore/ghr"), "html_url")
      )
    )
  )

  expect_true(
    all(
      grepl(
        "^https://raw.githubusercontent",
        ghr_pull(ghr_get("maurolepore/ghr/R"), "download_url")
      )
    )
  )
})
