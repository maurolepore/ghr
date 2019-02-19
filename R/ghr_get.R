ghr_get_impl <- function(path, ref = "master") {
  branch <- ref
  pieces <- strsplit(path, "@")[[1]]
  uses_at <- length(pieces) > 1
  stop_invalid_ref(path, ref, uses_at)
  if (uses_at) {
    path <- pieces[[1]]
    branch <- pieces[[2]]
  }

  gh::gh(ghr_path(path), ref = branch)
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
#' @param path A string formatted as "owner/repo/subdir" or
#'   "owner/repo/subdir\@branch", e.g.: "maurolepore/ghr/reference@gh-pages".
#' @param ref Branch name.
#'
#' @family functions to get github responses
#' @seealso ghr_fields
#'
#' @return A list.
#' @export
#'
#' @examples
#' gh_response <- ghr_get("maurolepore/ghr")
#' class(gh_response)
#' length(gh_response)
#' str(gh_response[[1]])
#'
#' # The request to GitHub happens only the first time you call ghr_get()
#' system.time(ghr_get("maurolepore/ghr/R"))
#' # Later calls take no time because the first call is memoised
#' system.time(ghr_get("maurolepore/ghr/R"))
#'
#' ghr_pull(ghr_get("maurolepore/ghr", ref = "gh-pages"), "path")
#' # Same
#' ghr_pull(ghr_get("maurolepore/ghr@gh-pages"), "path")
#'
#' ghr_pull(ghr_get("maurolepore/ghr/reference@gh-pages"), "path")
ghr_get <- memoise::memoise(ghr_get_impl)

#' Get the name of all branches of a GitHub repository.
#'
#' @inheritParams ghr_get
#'
#' @family functions to get github responses
#' @seealso ghr_fields
#'
#' @return A character string.
#' @export
#'
#' @examples
#' ghr_show_branches("maurolepore/ghr")
ghr_show_branches <- function(path) {
  owner_repo <- owner_repo(path)
  purrr::map_chr(gh::gh(glue::glue("/repos/{owner_repo}/branches")), "name")
}

# Helpers -----------------------------------------------------------------

#' Convert a path such as owner/repo/subdir into an `endpoint` for `gh::gh()`.
#'
#' @inheritParams ghr_get
#'
#' @return A character string.
#'
#' @examples
#' ghr_path("maurolepore/ghr/tests/testthat")
#' @noRd
ghr_path <- function(path) {
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
