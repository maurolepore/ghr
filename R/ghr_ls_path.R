# FIXME: Add ... to pass arguments to gh::gh()

NULL

# FIXME: Remove ghr_ls?

#' @inherit ghr_ls
#' @inheritParams fs::dir_ls
#' @export
#'
#' @examples
#' # FIXME: Can I get around this problem?
#' ghr_ls_path(
#'   "scbi-forestgeo/scbi-forestgeo-data/tree_main_census", recursive = TRUE
#' )
#' # FIXME: Nicer error message?
#' ghr_ls_path("superbadpath")
#'
#' # FIXME: Should return paths, not file names
#' ghr_ls_path("maurolepore/ghr")
#' # FIXME: Add hint?, maybe via rise via rlang
#' ghr_ls_path("maurolepore/ghr/DESCRIPTION")
#'
#' length(ghr_ls_path("maurolepore/ghr"))
#' length(ghr_ls_path("maurolepore"))
#' # FIXME add limit
#' length(ghr_ls_path("maurolepore", .limit = 50))
#'
#' path <- "maurolepore/ghr/tests"
#' ghr_ls_path(path)
#' ghr_ls_path(path, regexp = "[.]R")
#' ghr_ls_path(path, regexp = "[.]R", invert = TRUE)
#' # FIXME: should be once
#' ghr_ls_path(path, regexp = "[.]r")
#' ghr_ls_path(path, regexp = "[.]r", ignore.case = TRUE)
#'
#' ghr_ls_path(path, recursive = TRUE, regexp = "[.]R")
#' ghr_ls_path(path, recursive = TRUE, regexp = "[.]R", invert = TRUE)
#' # FIXME: should be once
#' ghr_ls_path(path, recursive = TRUE, regexp = "[.]r")
#' ghr_ls_path(path, recursive = TRUE, regexp = "[.]r", ignore.case = TRUE)
ghr_ls_path <- function(path,
                        regexp = NULL,
                        ignore.case = FALSE,
                        invert = FALSE,
                        recursive = FALSE)  {
  if (!recursive) {
    out <- ghr_ls(
      path,
      regexp = regexp,
      ignore.case = ignore.case,
      invert = invert
    )
    return(out)
  }

  out <- grep_ls(
    recurse_path(path),
    regexp,
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

