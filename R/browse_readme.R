#' ghr_browse_file(ghr_get("maurolepore/ghr"), "README.md")
html_file <- function(response, file) {
  urls <- ghr_html_url(response)
  this_url <- grepl(file, fs::path_file(urls))
  urls[this_url]
}

ghr_browse_file <- function(response, file) {
  utils::browseURL(html_file(response, file = file))
}
