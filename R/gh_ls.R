#' List files on GitHub.
#'
#' This function works on GitHub as [fs::dir_ls()] on a the file system.
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
#' gh_ls("forestgeo")
#' gh_ls("forestgeo/fgeo")
#' gh_ls("forestgeo/fgeo/tests")
#' gh_ls("forestgeo/fgeo/tests/testhat")
#' gh_ls("forestgeo/fgeo/tests/bad-dir")
gh_ls <- function(path) {
  n <- length(split_url(path))
  dplyr::case_when(
    n == 1 ~ ls_owner(owner = owner(path)),
    n == 2 ~ ls_repo(repo = owner_repo(path)),
    n >= 3 ~ ls_content(repo = owner_repo(path), subdir = subdir(path)),
    TRUE   ~ stop("Bad request", call. = FALSE)
  )
}

ls_request <- function(request) {
  purrr::map_chr(gh::gh(request), "name")
}

split_url <- function(x) {
  strsplit(x, "/")[[1]]
}
testthat::expect_equal(split_url("owner/repo"), c("owner", "repo"))

owner <- function(x) {
  split_url(x)[[1]]
}
testthat::expect_equal(owner("owner/repo"), "owner")
testthat::expect_equal(owner("owner"), "owner")

repo <- function(x) {
  split_url(x)[[2]]
}
testthat::expect_equal(repo("owner/repo"), "repo")
testthat::expect_error(repo("owner"), "out of bounds")

owner_repo <- function(x) {
  paste0(owner(x), "/", repo(x))
}
testthat::expect_equal(owner_repo("owner/repo"), "owner/repo")
testthat::expect_error(owner_repo("owner"), "out of bounds")

subdir <- function(x) {
  stopifnot(length(split_url(x)) >= 3)
  paste0(split_url(x)[c(-1, -2)], collapse = "/")
}
testthat::expect_equal(subdir("owner/repo/sub1/sub2"), "sub1/sub2")
testthat::expect_error(subdir("owner/repo"), "length.*>= 3 is not TRUE")

ls_owner <- function(owner) {
  ls_request(glue::glue("/users/{owner}/repos"))
}

ls_repo <- function(repo) {
  ls_request(glue::glue("/repos/{repo}/contents/"))
}

ls_content <- function(repo, subdir = NULL) {
  ls_request(glue::glue("/repos/{repo}/contents/{subdir}"))
}
