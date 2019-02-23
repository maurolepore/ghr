#' List paths in a GitHub directory.
#'
#' @param path
#'
#' @return
#' @export
#'
#' @examples
#' ghr_ls_path("maurolepore")
#' ghr_ls_path("maurolepore/tor")
#' ghr_ls_path("maurolepore/tor/tests")
#' ghr_ls_path("maurolepore/tor/tests/testthat")
ghr_ls_path_impl <- function(path) {
  n_pieces <- as.character(length(split_url(path)))
  out <- switch(
    n_pieces,
    "1" = fs::path(owner(path), ghr_ls(path)),
    "2" = fs::path(owner(path), repo(path), ghr_ls(path)),
    fs::path(owner(path), repo(path), ghr_ls(path))
  )

  out
}








#' recurse_path("maurolepore/ghr/tests/")
#' Nothing to list
#' recurse_path("maurolepore/ghr/R/ghr_ls.R")
#' @importFrom rlang %||%
#' @noRd
recurse_path <- function(path, result = NULL) {
  out <- suppressWarnings(
    unlist(purrr::map(path, ~ ghr_ls_path_impl(.x)))
  )
  if (identical(out, character(0))) {
    return(result)
  } else {
    recurse_path(out, result = c(path, out))
  }
}
