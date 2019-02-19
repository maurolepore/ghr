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
#' gh_response <- ghr_get("hadley/babynames/data-raw")
#' ghr_show_fields(gh_response)
#' ghr_pull(gh_response, "name")
#'
#' # Working with non-default branches
#' ghr_pull(ghr_get("r-lib/usethis", ref = "gh-pages"), "path")
#' # Same
#' ghr_pull(ghr_get("r-lib/usethis@gh-pages"), "path")
#' ghr_pull(ghr_get("r-lib/usethis/news@gh-pages"), "path")
ghr_show_fields <- function(gh_response) {
  stopifnot(inherits(gh_response, "gh_response"))
  names(gh_response[[1]])
}

#' @rdname ghr_show_fields
#' @export
ghr_pull <- function(gh_response, field) {
  stopifnot(inherits(gh_response, "gh_response"))

  tryCatch(
    unlist(purrr::map(gh_response, field)),
    error = function(e)  {
      stop("Can't pull '", field, "' from this `gh_response`.", call. = FALSE)
    }
  )
}
