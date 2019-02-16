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
  if (n == 1L) {
    out <- ls_owner(owner = owner(path))
  } else if (n == 2L) {
    out <- ls_repo(repo = owner_repo(path))
  } else if (n >= 3L) {
    out <- ls_content(repo = owner_repo(path), subdir = subdir(path))
  } else {
    stop("Bad request", call. = FALSE)
  }
  out
}

# gh_ls <- function(path) {
#   n <- length(split_url(path))
#   dplyr::case_when(
#     n == 1 ~ ls_owner(owner = owner(path)),
#     n == 2 ~ ls_repo(repo = owner_repo(path)),
#     n >= 3 ~ ls_content(repo = owner_repo(path), subdir = subdir(path)),
#     TRUE   ~ stop("Bad request", call. = FALSE)
#   )
# }

split_url <- function(x) {
  strsplit(x, "/")[[1]]
}

owner <- function(x) {
  split_url(x)[[1]]
}

repo <- function(x) {
  split_url(x)[[2]]
}

owner_repo <- function(x) {
  paste0(owner(x), "/", repo(x))
}

subdir <- function(x) {
  stopifnot(length(split_url(x)) >= 3)
  paste0(split_url(x)[c(-1, -2)], collapse = "/")
}

ls_owner <- function(owner) {
  ls_request(glue::glue("/users/{owner}/repos"))
}

ls_repo <- function(repo) {
  ls_request(glue::glue("/repos/{repo}/contents/"))
}

ls_content <- function(repo, subdir = NULL) {
  ls_request(glue::glue("/repos/{repo}/contents/{subdir}"))
}

ls_request <- function(request) {
  purrr::map_chr(gh::gh(request), "name")
}

