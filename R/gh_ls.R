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







#' @examples
#' gh_response <- gh_get("hadley/babynames/data-raw")
#' ghr_fields(gh_response)
#'
#' ghr_pull(gh_response, "name")
#' # Shortcuts
#' ghr_path(gh_response)
#' ghr_html_url(gh_response)
#' ghr_download_url(gh_response)
#'
#' # Branches
#' ghr_path(gh_get("r-lib/usethis", ref = "gh-pages"))
#' # Same
#' ghr_path(gh_get("r-lib/usethis@gh-pages"))
#' ghr_path(gh_get("r-lib/usethis/news@gh-pages"))
gh_get_ <- function(path, ref = "master") {
  branch <- ref
  pieces <- strsplit(path, "@")[[1]]
  if (length(pieces) > 1) {
    path <- pieces[[1]]
    branch <- pieces[[2]]
  }

  gh::gh(gh_path(path), ref = branch)
}
gh_get <- memoise::memoise(gh_get_)

ghr_fields <- function(gh_response) {
  stopifnot(inherits(gh_response, "gh_response"))
  names(gh_response[[1]])
}

ghr_pull <- function(gh_response, field) {
  stopifnot(inherits(gh_response, "gh_response"))
  purrr::map_chr(gh_response, field)
}

with_field <- function(field) {
  function(gh_response)
  ghr_pull(gh_response, field = field)
}
ghr_path <- with_field("path")
ghr_html_url <- with_field("html_url")
ghr_download_url <- with_field("download_url")



gh_branches <- function(path) {
  path_ <- gh_path(path)
  gh::gh(glue::glue("{path_}/branches"))
}
