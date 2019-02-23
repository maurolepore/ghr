ghr_ls_path <- function(path,
                        regexp = NULL,
                        ignore.case = FALSE,
                        invert = FALSE,
                        recursive = FALSE,
                        ...)  {
  if (!recursive) {
    out <- ghr_ls(
      path,
      ...,
      regexp = regexp,
      ignore.case = ignore.case,
      invert = invert
    )
    return(out)
  }

  out <- grep_ls(
    regexp,
    recurse_path(path),
    ignore.case = ignore.case,
    invert = invert
  )

  out
}

#' recurse_path("maurolepore/ghr/tests/")
#' Nothing to list
#' recurse_path("maurolepore/ghr/R/ghr_ls.R")
#' @param Arguments passed to [gh::gh()].
#' @noRd
recurse_path <- function(path, result = NULL) {
  out <- suppressWarnings(
    unlist(purrr::map(path, ~ ls_path(.x)))
  )
  if (identical(out, character(0))) {
    return(result)
  } else {
    recurse_path(out, result = c(path, out))
  }
}

#' ghr_ls_path("maurolepore")
#' ghr_ls_path("maurolepore/tor")
#' ghr_ls_path("maurolepore/tor/tests")
#' ghr_ls_path("maurolepore/tor/tests/testthat")
#' @noRd
ls_path <- function(path) {
  n_pieces <- as.character(length(split_url(path)))
  out <- switch(
    n_pieces,
    "1" = fs::path(owner(path), ghr_ls(path)),
    "2" = fs::path(owner(path), repo(path), ghr_ls(path)),
    fs::path(owner(path), repo(path), ghr_ls(path))
  )

  out
}

