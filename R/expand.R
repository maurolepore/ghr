#' Expand GitHub paths.
#'
#' @inheritParams gh_ls
#' @param branch Character vector giving the branch name of a GitHub repo.
#'
#' @return Character vector.
#' @export
#'
#' @examples
gh_expand_home <- function(path, branch = "master") {
  blob <- blobize(path, branch = branch)
  glue::glue("https://github.com/{blob}")
}

blobize <- function(path, branch = "master") {
  piece_apply(
    path,
    f1 = owner,
    f2 = owner_repo,
    f3 = function(path) {
      paste0(owner_repo(path), "/blob/", branch, "/", subdir(path))
    }
  )
}

