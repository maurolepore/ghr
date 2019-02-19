context("ghr_ls")

source(test_path("skip_if_net_down.R"))

test_that("ghr_ls is sensitive to all arguments", {
  skip_if_net_down()

  expect_true("DESCRIPTION" %in% ghr_ls("maurolepore/ghr"))

  out <- unclass(ghr_ls("maurolepore/ghr/R", regexp = "ghr_ls"))
  attr(out, "path") <- NULL
  expect_equal(out, "R/ghr_ls.R")

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

test_that("ghr_ls outputs the expected class", {
  skip_if_net_down()

  expect_is(ghr_ls("maurolepore/tor"), "ghr_path_ls")
  expect_equal(
    class(new_ghr_path_ls(ghr_ls("maurolepore/tor"))),
    c("ghr_path_ls", "character")
  )
})

test_that("ghr_ls has attribute path", {
  path <- "maurolepore/tor"
  expect_equal(attributes(ghr_ls(path))$path, path)
})
