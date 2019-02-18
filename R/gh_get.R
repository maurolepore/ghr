gh_get_impl <- function(path, ref = "master") {
  branch <- ref
  pieces <- strsplit(path, "@")[[1]]
  uses_at <- length(pieces) > 1
  stop_invalid_ref(path, ref, uses_at)
  if (uses_at) {
    path <- pieces[[1]]
    branch <- pieces[[2]]
  }

  gh::gh(gh_path(path), ref = branch)
}

stop_invalid_ref <- function(path, ref, uses_at) {
  uses_ref <- uses_at || ref != "master"
  if (uses_ref && length(split_url(path)) == 1L) {
    stop(
      "`ref` makes no sense for a `path` at the 'owner' level.\n",
      "Did you forget to specify the 'repo' component of the `path`?",
      call. = FALSE
    )
  }
}

#' Get a response from the GitHub API.
#'
#' @param path A string formatted as "owner/repo/subdir_1/subdir_2/subdir_n".
#' @param ref Branch name.
#'
#' @family functions to get github responses
#' @seealso ghr_fields
#'
#' @return A list.
#' @export
#'
#' @examples
#' gh_get("r-lib/usethis")
#'
#' # The request to GitHub happens only the first time you call gh_get()
#' system.time(gh_get("r-lib/usethis/R"))
#' # Later calls take no time because the first call is memoised
#' system.time(gh_get("r-lib/usethis/R"))
#'
#' ghr_path(gh_get("r-lib/usethis", ref = "gh-pages"))
#' # Same
#' ghr_path(gh_get("r-lib/usethis@gh-pages"))
#' ghr_path(gh_get("r-lib/usethis/news@gh-pages"))
gh_get <- memoise::memoise(gh_get_impl)

#' Get the name of all branches of a GitHub repository.
#'
#' @inheritParams gh_get
#'
#' @family functions to get github responses
#' @seealso ghr_fields
#'
#' @return A character string.
#' @export
#'
#' @examples
#' gh_branches("r-lib/usethis")
gh_branches <- function(path) {
  owner_repo <- owner_repo(path)
  purrr::map_chr(gh::gh(glue::glue("/repos/{owner_repo}/branches")), "name")
}

# Helpers -----------------------------------------------------------------

#' Convert a path such as owner/repo/subdir into an `endpoint` for `gh::gh()`.
#'
#' @inheritParams gh_get
#'
#' @return A character string.
#'
#' @examples
#' gh_path("r-lib")
#' gh_path("r-lib/gh")
#' gh_path("r-lib/gh/tests")
#' gh_path("r-lib/gh/tests/testthat")
#' @noRd
#' @keywords internal
gh_path <- function(path) {
  n_pieces <- as.character(length(split_url(path)))
  switch(
    n_pieces,
    "1" = request_owner(path),
    "2" = request_repo(path),
    request_subdir(path)
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
