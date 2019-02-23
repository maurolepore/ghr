#' Show and pull available fields of a GitHub response.
#'
#' @param gh_response A list object of class "gh_response".
#' @param field Character string giving the name of the the element to
#'   extract from the github-response list.
#'
#' @family functions to work with github responses
#' @seealso ghr_get gh_branches
#'
#' @return A character string.
#' @export
#'
#' @examples
#' gh_response <- ghr_get("maurolepore/ghr/R")
#'
#' ghr_show_fields(gh_response)
#'
#' ghr_pull(gh_response, "name")
#'
#' # Working with non-default branches
#' ghr_pull(ghr_get("maurolepore/ghr", ref = "gh-pages"), "path")
#' # Same
#' ghr_pull(ghr_get("maurolepore/ghr@gh-pages"), "path")
#'
#' ghr_pull(ghr_get("maurolepore/ghr/reference@gh-pages"), "path")
ghr_show_fields <- function(gh_response) {
  stopifnot(inherits(gh_response, "gh_response"))
  names(gh_response[[1]])
}

#' @rdname ghr_show_fields
#' @export
ghr_pull <- function(gh_response, field) {
  stopifnot(inherits(gh_response, "gh_response"))

  out <- unlist(purrr::map(gh_response, field))
  warn_null_result(out)
  out
}

warn_null_result <- function(out) {
  if (is.null(out)) {
    warning(
      "GitHub responded with a `NULL` value. Is this what you expect?",
      call. = FALSE
    )
  }

  invisible(out)
}
