
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ghr

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/maurolepore/ghr.svg?branch=master)](https://travis-ci.org/maurolepore/ghr)
[![Coveralls test
coverage](https://coveralls.io/repos/github/maurolepore/ghr/badge.svg)](https://coveralls.io/r/maurolepore/ghr?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/ghr)](https://cran.r-project.org/package=ghr)
<!-- badges: end -->

The ghr (GitHub-R) package helps you to request information to the
GitHub-API using an intuitive syntax, similar to that of
`remotes::install_github()`. For example, this is a valid path
`maurolepore/ghr@master`. Also this one:
`maurolepore/ghr/reference@gh-pages`.

## Installation

``` r
install.packages("devtools")
devtools::install_github("maurolepore/ghr")
```

## Example

``` r
library(magrittr)
library(ghr)
```

Use `ghr_get()` to get a GitHub-API response. Notice that the call is
memoised.

``` r
system.time(ghr_get("maurolepore/ghr"))
#>    user  system elapsed 
#>    0.11    0.00    0.44
# Takes no time because the first call is memoised
system.time(ghr_get("maurolepore/ghr"))
#>    user  system elapsed 
#>       0       0       0
```

Use `ghr_show_fields()` to see what fields are available for a given
`path`.

``` r
response <- ghr_get(path = "maurolepore/ghr/tests")
class(response)
#> [1] "gh_response" "list"

ghr_show_fields(response)
#>  [1] "name"         "path"         "sha"          "size"        
#>  [5] "url"          "html_url"     "git_url"      "download_url"
#>  [9] "type"         "_links"
```

Use `ghr_pull()` to access specific fields of the GitHub response.

``` r
ghr_pull(response, "name")
#> [1] "spelling.R" "testthat.R" "testthat"
```

Use `ghr_ls()` as shortcut for
`ghr_pull(ghr_get("owner/repo/subdir@branch"), field = "path")`. It
offers an interface similar to `fs::dir_ls()`.

``` r
path <- "maurolepore/tor/inst/extdata/mixed"

# The first call make the request
system.time(ghr_ls(path))
#>    user  system elapsed 
#>    0.00    0.00    0.11
# Takes no time because the first call is memoised
system.time(ghr_ls(path))
#>    user  system elapsed 
#>       0       0       0

ghr_ls(path, regexp = "[.]csv$")
#> [1] "inst/extdata/mixed/csv.csv"
ghr_ls(path, regexp = "[.]csv$", invert = TRUE)
#> [1] "inst/extdata/mixed/lower_rdata.rdata"
#> [2] "inst/extdata/mixed/rda.rda"          
#> [3] "inst/extdata/mixed/upper_rdata.RData"

ghr_ls(path, regexp = "[.]RDATA$", ignore.case = FALSE)
#> character(0)
ghr_ls(path, regexp = "[.]RDATA$", ignore.case = TRUE)
#> [1] "inst/extdata/mixed/lower_rdata.rdata"
#> [2] "inst/extdata/mixed/upper_rdata.RData"
```

The `path` argument to `ghr_get()` understands a syntax as
`owner/repo/path@branch`

``` r
ghr_show_branches("maurolepore/ghr")
#> [1] "gh-pages" "master"

"maurolepore/ghr@gh-pages" %>% 
  ghr_get() %>% 
  ghr_pull("name")
#>  [1] "LICENSE.html"  "authors.html"  "docsearch.css" "docsearch.js" 
#>  [5] "index.html"    "link.svg"      "pkgdown.css"   "pkgdown.js"   
#>  [9] "pkgdown.yml"   "reference"
```

You can pull the URLs to read or browse multiple files at once.

``` r
"maurolepore/tor/inst/extdata/csv" %>% 
  ghr_get() %>% 
  ghr_pull("download_url") %>%
  lapply(read.csv, stringsAsFactors = FALSE)
#> [[1]]
#>   x
#> 1 1
#> 2 2
#> 
#> [[2]]
#>   y
#> 1 a
#> 2 b
```

``` r
html_urls <- "maurolepore/tor/inst/extdata/csv" %>% 
  ghr_get() %>% 
  ghr_pull("html_url")
html_urls
#> [1] "https://github.com/maurolepore/tor/blob/master/inst/extdata/csv/csv1.csv"
#> [2] "https://github.com/maurolepore/tor/blob/master/inst/extdata/csv/csv2.csv"

if (interactive()) {
  html_urls %>% 
    lapply(utils::browseURL)
}
```

-----

## Acknowledgements

Thanks to Gábor Csárdi et. al for the [gh
package](https://github.com/maurolepore/ghr) and to Francois Michonneau,
James Balamuta, Noam Ross and Bryce Mecum for sharing their ideas and
code.
