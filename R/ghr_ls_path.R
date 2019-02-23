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
    fs::path(owner(path), repo(path), ghr_pull(ghr_get(path), "path"))
  )

  out
}

recurse_path <- function(path) {
  sub_path <- ghr_ls_path_impl(path)
  if (is.null(sub_path)) {
    return(path)
  } else {
    tryCatch(
      suppressWarnings(recurse_path(sub_path)),
      error = function(e) return(path)
    )
  }
}

# recurse_path("maurolepore/tor/tests")

# ghr_ls_recursive("maurolepore/tor")
# ghr_ls_recursive("maurolepore/tor/vignettes")
ghr_ls_recursive <- function(path) {
  out <- suppressWarnings(purrr::map(recurse_path(path), recurse_path))
  unlist(out)
}
