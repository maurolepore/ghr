#' Show and pull available fields of a GitHub response.
#'
#' @param gh_response A list object of class "gh_response".
#' @param field Character string giving the name of the the element to
#'   extract from the github-response list.
#'
#' @family functions to work with github responses
#' @seealso gh_get gh_branches
#'
#' @return A character string.
#' @export
#'
#' @examples
#' gh_response <- gh_get("hadley/babynames/data-raw")
#' ghr_fields(gh_response)
#'
#' ghr_pull(gh_response, "name")
#' # Shortcuts
#' ghr_path(gh_response)
#' ghr_html_url(gh_response)
#' ghr_download_url(gh_response)
#'
#' # Working with non-default branches
#' ghr_path(gh_get("r-lib/usethis", ref = "gh-pages"))
#' # Same
#' ghr_path(gh_get("r-lib/usethis@gh-pages"))
#' ghr_path(gh_get("r-lib/usethis/news@gh-pages"))
ghr_fields <- function(gh_response) {
  stopifnot(inherits(gh_response, "gh_response"))
  names(gh_response[[1]])
}

#' @rdname ghr_fields
#' @export
ghr_pull <- function(gh_response, field) {
  stopifnot(inherits(gh_response, "gh_response"))
  purrr::map_chr(gh_response, field)
}

with_field <- function(field) {
  function(gh_response)
    ghr_pull(gh_response, field = field)
}
#' @rdname ghr_fields
#' @export
ghr_path <- with_field("path")
#' @rdname ghr_fields
#' @export
ghr_html_url <- with_field("html_url")
#' @rdname ghr_fields
#' @export
ghr_download_url <- with_field("download_url")
