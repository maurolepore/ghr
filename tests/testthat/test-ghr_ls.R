context("ghr_ls")

source(test_path("skip_if_net_down.R"))

test_that("ghr_ls is sensitive to all arguments", {
  skip_if_net_down()

  expect_true("DESCRIPTION" %in% ghr_ls("maurolepore/ghr"))
  expect_equal(ghr_ls("maurolepore/ghr/R", regexp = "ghr_ls"), "R/ghr_ls.R")

  expect_true("R/ghr_ls.R" %in% ghr_ls("maurolepore/ghr/R", regexp = "ghr_ls"))
  expect_false(
    "R/ghr_ls.R" %in% ghr_ls("maurolepore/ghr/R", "ghr_ls", invert = TRUE)
  )

  expect_false(
    "R/ghr_ls.R" %in% ghr_ls("maurolepore/ghr/R", "GHR_LS")
  )
  expect_true(
    "R/ghr_ls.R" %in% ghr_ls("maurolepore/ghr/R", "GHR_LS", ignore.case = TRUE)
  )
})

test_that("ghr_ls finds a value in a page after the first one", {
  skip_if_net_down()
  expect_true("ghr" %in% ghr_ls("maurolepore", .limit = 100))
})
