#' List files in a GitHub 'directory'.
#'
#' @inheritParams ghr_get
#' @inheritParams base::grep
#' @param regexp A regular expression (e.g. [.]csv$) passed on to grep() to
#'   filter paths.
#'
#' @return A character string.
#' @export
#'
#' @examples
#' # The first call make the request
#' system.time(ghr_ls("maurolepore/ghr/R"))
#' # Takes no time because the first call is memoised
#' system.time(ghr_ls("maurolepore/ghr/R"))
#'
#' ghr_ls("maurolepore/ghr/R")
#' ghr_ls("maurolepore/ghr/R", regexp = "get")
#' ghr_ls("maurolepore/ghr/R", regexp = "get", invert = TRUE)
#' ghr_ls("maurolepore/ghr/R", regexp = "GET")
#' ghr_ls("maurolepore/ghr/R", regexp = "GET", ignore.case = TRUE)
ghr_ls <- function(path,
  regexp = NULL,
  ignore.case = FALSE,
  invert = FALSE) {
  paths <- ghr_pull(ghr_get(path), "path")
  pick <- seq_along(paths)
  if (!is.null(regexp)) {
    pick <- grep(regexp, paths, ignore.case = ignore.case, invert = invert)
  }
  paths[pick]
}
