context("ghr_ls")

source(test_path("skip_if_net_down.R"))

test_that("ghr_ls warns if nothing matches the given `regexp`", {
  expect_warning(
    ghr_ls("maurolepore/ghr", regexp = "bad"),
    "Nothing in.*matches"
  )
})

test_that("ghr_ls is sensitive to all arguments", {
  skip_if_net_down()

  expect_true("DESCRIPTION" %in% ghr_ls("maurolepore/ghr"))
  expect_equal(ghr_ls("maurolepore/ghr/R", regexp = "ghr_ls"), "R/ghr_ls.R")

  expect_true("R/ghr_ls.R" %in% ghr_ls("maurolepore/ghr/R", regexp = "ghr_ls"))
  expect_false(
    "R/ghr_ls.R" %in%
      ghr_ls("maurolepore/ghr/R", regexp = "ghr_ls", invert = TRUE)
  )

  expect_warning(
    expect_false(
      "R/ghr_ls.R" %in%
        ghr_ls("maurolepore/ghr/R", regexp = "GHR_LS")
    ),
    "Nothing.*matches"
  )
  expect_true(
    "R/ghr_ls.R" %in%
      ghr_ls("maurolepore/ghr/R", regexp = "GHR_LS", ignore.case = TRUE)
  )
})

test_that("ghr_ls finds a value in a page after the first one", {
  skip_if_net_down()
  expect_true("ghr" %in% ghr_ls("maurolepore", .limit = 100))
})

context("ghr_ls_download_url")

test_that("ghr_ls_download_url errs with `path` at the owner level only", {
  expect_error(
    ghr_ls_download_url("maurolepore"),
    "Did you forget to specify a GitHub repo?"
  )
})

test_that("ghr_ls_download_url works with `path` at the repo level or deeper", {
  expect_true(all(grepl(
    "https://raw.githubusercontent.com",
    ghr_ls_download_url("maurolepore/ghr")
  )))

  expect_true(all(grepl(
    "https://raw.githubusercontent.com",
    ghr_ls_download_url("maurolepore/ghr/R")
  )))
})

context("ghr_ls_html_url")

test_that("ghr_ls_html_url works with `path` at the repo level or deeper", {
  expect_true(all(grepl(
    "https://github.com",
    ghr_ls_html_url("maurolepore/ghr/R")
  )))
})
