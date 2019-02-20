#' List files in a GitHub 'directory'.
#'
#' @inheritParams ghr_get
#' @inheritParams base::grep
#' @param regexp A regular expression (e.g. `[.]csv$`) passed on to grep() to
#'   filter paths.
#' @param ... Arguments passed to [gh::gh()] via [ghr_get()].
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
#' @family shortcuts for common tasks
ghr_ls <- function(path,
                   regexp = NULL,
                   ignore.case = FALSE,
                   invert = FALSE,
                   ...) {
  if (identical(length(split_url(path)), 1L)) {
    paths <- ghr_pull(ghr_get(path, ...), "name")
  } else {
    paths <- ghr_pull(ghr_get(path, ...), "path")
  }

  pick <- seq_along(paths)
  if (!is.null(regexp)) {
    pick <- grep(regexp, paths, ignore.case = ignore.case, invert = invert)
  }
  paths[pick]
}

# FIXME: Replace ghr_ls()
ghr_ls_xxx <- function(path,
                       regexp = NULL,
                       ignore.case = FALSE,
                       invert = FALSE,
                       ...) {
  if (only_owner(path)) {
    out <- ghr_ls_field(
      path,
      field = "name",
      regexp = regexp,
      ignore.case = ignore.case,
      invert = invert,
      ...
    )
    return(out)
  }

  ghr_ls_field(
    path,
    field = "path",
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )
}

only_owner <- function(path) {
  identical(length(split_url(path)), 1L)
}

ghr_ls_field <- function(path,
                         field,
                         regexp = NULL,
                         ignore.case = FALSE,
                         invert = FALSE,
                         ...) {
  field_ls <- ghr_pull(ghr_get(path, ...), field = field)
  if (is.null(regexp)) {
    return(field_ls)
  }

  if (length(fields_ls) == 0L) {
    abort(sprintf("Can't find files matching '%s' in:\n '%s'", regexp, path))
  }

  pick <- grep(regexp, field_ls, ignore.case = ignore.case, invert = invert)
  field_ls[pick]
}

ghr_ls_download_url <- function(path,
                                regexp = NULL,
                                ignore.case = FALSE,
                                invert = FALSE,
                                ...) {
  stop_invalid_path(path)

  ghr_ls_field(
    path,
    field = "download_url",
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )
}

ghr_ls_html_url <- function(path,
                            regexp = NULL,
                            ignore.case = FALSE,
                            invert = FALSE,
                            ...) {
  stop_invalid_path(path)

  ghr_ls_field(
    path,
    field = "html_url",
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )
}

stop_invalid_path <- function(path) {
  if (identical(length(split_url(path)), 1L)) {
    stop("No such url is available at ", path, ".", call. = FALSE)
  }

  invisible(path)
}
