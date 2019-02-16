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
  end <- purrr::map_chr(gh::gh(gh_call(path)), "name")
  out <- glue::glue("path/{end}")
  names(out) <- out
  new_gh_path(out)
}

new_gh_path <- function(path, ...) {
  stopifnot(is.character(path))
  structure(path, class = c("gh_path", class(path)))
}

#' Create a request for GitHub contents that gh::gh() understands.
#'
#' @param path A string formatted as "owner/repo/subdir_1/subdir_2/subdir_n".
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' gh_call("owner")
#' gh_call("owner/repo")
#' gh_call("owner/repo/subdir")
#' gh_call("owner/repo/subdir_1/subdir_2/subdir_3")
#' gh_call("O/R/S1/S2/S3")
gh_call <- function(path) {
  out <- piece_apply(path, request_owner, request_repo, request_subdir)
  tolower(out)
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
  glue::glue("/users/{owner_repo}/repos")
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
