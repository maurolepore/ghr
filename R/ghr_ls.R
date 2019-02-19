#' List files in a GitHub 'directory'.
#'
#' @inheritParams ghr_get
#' @inheritParams base::grep
#' @param regexp A regular expression (e.g. `[.]csv$`) passed on to grep() to
#'   filter paths.
#'
#' @return A character string.
#' @export
#'
#' @examples
#' path <- "maurolepore/tor/inst/extdata/mixed"
#'
#' # The first call make the request
#' system.time(ghr_ls(path))
#' # Takes no time because the first call is memoised
#' system.time(ghr_ls(path))
#'
#' ghr_ls(path, regexp = "[.]csv$")
#' ghr_ls(path, regexp = "[.]csv$", invert = TRUE)
#'
#' ghr_ls(path, regexp = "[.]RDATA$", invert = TRUE, ignore.case = FALSE)
#' ghr_ls(path, regexp = "[.]RDATA$", invert = TRUE, ignore.case = TRUE)
ghr_ls <- function(path,
                   regexp = NULL,
                   ignore.case = FALSE,
                   invert = FALSE) {
  paths <- ghr_pull(ghr_get(path), "path")
  pick <- seq_along(paths)
  if (!is.null(regexp)) {
    pick <- grep(regexp, paths, ignore.case = ignore.case, invert = invert)
  }

  new_ghr_path_ls(paths[pick], path)
}

new_ghr_path_ls <- function(x, path) {
  if (inherits(x, "ghr_path_ls")) {
    return(x)
  }

  structure(x, class = c("ghr_path_ls", class(x)), path = path)
}

#' @keywords internal
#' @export
#' @noRd
print.ghr_path_ls <- function(x, ...) {
  x_ <- unclass(x)
  attr(x_, "path") <- NULL
  print(x_)

  invisible(x)
}
