
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

The ghr package helps you to request information to the GitHub-API using
an intuitive syntax, similar to that of `remotes::install_github()`. For
example, this is a valid path `maurolepore/ghr@master`. Also this one:
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
#>    0.07    0.04    0.36
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

Use `ghr_ls()` as a shortcut for `ghr_pull(ghr_get(path), field =
"path"). It offers an interface similar to`fs::dir\_ls()\`.

``` r
ghr_ls("maurolepore/ghr/reference@gh-pages")
#> [1] "reference/gh_branches.html"       "reference/gh_get.html"           
#> [3] "reference/ghr-package.html"       "reference/ghr_branches.html"     
#> [5] "reference/ghr_fields.html"        "reference/ghr_get.html"          
#> [7] "reference/ghr_show_branches.html" "reference/ghr_show_fields.html"  
#> [9] "reference/index.html"
```

The `path` argument to `ghr_get()` understands a syntax as
`owner/repo/path@branch`

``` r
ghr_show_branches("maurolepore/ghr")
#> [1] "gh-pages" "master"

"maurolepore/ghr/reference@gh-pages" %>% 
  ghr_get() %>% 
  ghr_pull("name")
#> [1] "gh_branches.html"       "gh_get.html"           
#> [3] "ghr-package.html"       "ghr_branches.html"     
#> [5] "ghr_fields.html"        "ghr_get.html"          
#> [7] "ghr_show_branches.html" "ghr_show_fields.html"  
#> [9] "index.html"
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
