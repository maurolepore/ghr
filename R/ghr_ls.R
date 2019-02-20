#' List directories, html-URLs and download-URLs in a GitHub directory.
#'
#' @inheritParams ghr_get
#' @param ... Arguments passed to [gh::gh()] via [ghr_get()].
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
#'
#' # ghr_ls_download_url() and ghr_ls_html_url are similar
#' (d_url <- ghr_ls_download_url(path, regexp = "[.]csv$")[[1]])
#' read.csv(d_url)
#'
#' (h_url <- ghr_ls_html_url(path, regexp = "[.]csv$")[[1]])
#' if (interactive()) {
#'   utils::browseURL(h_url)
#' }
#' @family shortcuts for common tasks
ghr_ls <- function(path,
                   ...,
                   regexp = NULL,
                   ignore.case = FALSE,
                   invert = FALSE) {
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

  if (length(field_ls) == 0L) {
    abort(sprintf("Can't find files matching '%s' in:\n '%s'", regexp, path))
  }

  pick <- grep(regexp, field_ls, ignore.case = ignore.case, invert = invert)
  field_ls[pick]
}

#' @export
#' @rdname ghr_ls
ghr_ls_html_url <- function(path,
                            ...,
                            regexp = NULL,
                            ignore.case = FALSE,
                            invert = FALSE) {
  ghr_ls_field(
    path,
    field = "html_url",
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )
}

#' @export
#' @rdname ghr_ls
ghr_ls_download_url <- function(path,
                                ...,
                                regexp = NULL,
                                ignore.case = FALSE,
                                invert = FALSE) {
  stop_if_repo_is_missing(path)

  ghr_ls_field(
    path,
    field = "download_url",
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )
}

stop_if_repo_is_missing <- function(path) {
  if (identical(length(split_url(path)), 1L)) {
    stop(
      "Download URLs don't exist outside GitHub repositories.\n",
      "Did you forget to specify a GitHub repo?",
      call. = FALSE
    )
  }

  invisible(path)
}
