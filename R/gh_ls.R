gh_attributes <- function(path) {
  names(gh::gh(gh_path("r-lib/gh/tests/testthat"))[[1]])
}

gh_pull <- function(path, attribute) {
  purrr::map_chr(gh::gh(gh_path(path)), attribute)
}

#' Convert a path such as owner/repo/subdir into an `endpoint` for `gh::gh()`.
#'
#' @param path
#'
#' @return A character string.
#' @export
#'
#' @examples
#' gh_path("r-lib")
#' gh_path("r-lib/gh")
#' gh_path("r-lib/gh/tests")
#' gh_path("r-lib/gh/tests/testthat")
gh_path <- function(path) {
  piece_apply(path, request_owner, request_repo, request_subdir)
}

#' List files on GitHub and their html URLs.
#'
#' @param path A string formatted as "owner/repo/subdir_1/subdir_2/subdir_n".
#'
#' @return
#'   * `gh_ls()` returns a character vector giving the in a GitHub directory.
#'   * `gh_html()` returns the html URLs of the files in a GitHub directory.
#' @export
#'
#' @examples
#' gh_ls("r-lib")
#' gh_ls("r-lib/gh")
#' gh_ls("r-lib/gh/tests")
#' gh_ls("r-lib/gh/tests/testthat")
#'
#' gh_html("r-lib")
#' gh_html("r-lib/gh")
#' gh_html("r-lib/gh/tests")
#' gh_html("r-lib/gh/tests/testthat")
gh_ls <- function(path) {
  purrr::map_chr(gh::gh(gh_path(path)), "name")
}

gh_html <- function(path) {
  purrr::map_chr(gh::gh(gh_path(path)), "html_url")
}

piece_apply <- function(path, f1, f2, f3) {
  n_pieces <- as.character(length(split_url(path)))
  switch(
    n_pieces,
    "1" = f1(path),
    "2" = f2(path),
    f3(path)
  )
}

request_owner <- function(path) {
  glue::glue("/users/{path}/repos")
}
request_repo <- function(path) {
  owner_repo <- owner_repo(path)
  glue::glue("/repos/{owner_repo}/contents")
}
request_subdir <- function(path) {
  owner_repo <- owner_repo(path)
  subdir <- subdir(path)
  glue::glue("/repos/{owner_repo}/contents/{subdir}")
}

owner_repo <- function(x) {
  paste0(owner(x), "/", repo(x))
}

owner <- function(x) {
  split_url(x)[[1]]
}

repo <- function(x) {
  split_url(x)[[2]]
}

split_url <- function(x) {
  strsplit(x, "/")[[1]]
}

subdir <- function(x) {
  stopifnot(length(split_url(x)) >= 3)
  paste0(split_url(x)[c(-1, -2)], collapse = "/")
}
