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

# recurse_path("maurolepore/tor")
# recurse_path("maurolepore/tor/tests")
#' @importFrom rlang %||%
recurse_path <- function(path, result = NULL) {
  out <- suppressWarnings(unlist(purrr::map(path, ghr_ls_path_impl)))
  if (identical(out, character(0))) {
    return(c(result))
  } else {
    recurse_path(out, result = c(result, path))
  }
}
