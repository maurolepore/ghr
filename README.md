
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

The files you need are often scattered across multiple GitHub
organizations and repositories. How can you easily find and access them
from R?

The ghr (GitHub-R) package helps you to explore and access GitHub
directories from R, using a familiar syntax and interface.

## Installation

``` r
install.packages("devtools")
devtools::install_github("maurolepore/ghr")
```

## Example

### Overview

``` r
library(purrr)
library(ghr)

# Familiar syntax, similar to the `repo` argument of `remotes::install_github()`
path <- "maurolepore/tor/inst/extdata/mixed@master"

# Familiar interface, similar to `fs::dir_ls()`
ghr_ls(path)
#> [1] "inst/extdata/mixed/csv.csv"          
#> [2] "inst/extdata/mixed/lower_rdata.rdata"
#> [3] "inst/extdata/mixed/rda.rda"          
#> [4] "inst/extdata/mixed/upper_rdata.RData"
ghr_ls(path, regexp = "[.]csv$", invert = TRUE)
#> [1] "inst/extdata/mixed/lower_rdata.rdata"
#> [2] "inst/extdata/mixed/rda.rda"          
#> [3] "inst/extdata/mixed/upper_rdata.RData"

# Easily read data directly from GitHub into R
path %>% 
  ghr_ls_download_url(regexp = "[.]csv$") %>% 
  readr::read_csv()
#> Parsed with column specification:
#> cols(
#>   y = col_character()
#> )
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

### Details

Use `ghr_get()` to get a GitHub-API response. Notice that the call is
memoised.

``` r
system.time(ghr_get("maurolepore/ghr"))
#>    user  system elapsed 
#>    0.01    0.00    0.08
# Takes no time because the first call is memoised
system.time(ghr_get("maurolepore/ghr"))
#>    user  system elapsed 
#>       0       0       0

response <- ghr_get(path = "maurolepore/ghr")
class(response)
#> [1] "gh_response" "list"
```

Use `ghr_show_fields()` to see what fields are available for a given
`path`.

``` r
ghr_show_fields(response)
#>  [1] "name"         "path"         "sha"          "size"        
#>  [5] "url"          "html_url"     "git_url"      "download_url"
#>  [9] "type"         "_links"
```

Use `ghr_pull()` to access specific fields of the GitHub response.

``` r
ghr_pull(response, "name")
#>  [1] ".Rbuildignore" ".github"       ".gitignore"    ".travis.yml"  
#>  [5] "DESCRIPTION"   "LICENSE.md"    "NAMESPACE"     "NEWS.md"      
#>  [9] "R"             "README.Rmd"    "README.md"     "ghr.Rproj"    
#> [13] "inst"          "man"           "tests"         "vignettes"
```

Use `ghr_ls()`, `ghr_ls_download_url()` and `ghr_ls_htrml_url()` are
shortcuts for `ghr_pull(ghr_get(path), field = "<field>")`. They offer
an interface similar to `fs::dir_ls()`.

``` r
path <- "maurolepore/tor/inst/extdata/mixed"
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

`ghr_ls_download_url()` and `ghr_ls_htrml_url()` are most useful in
combination with `purrr::map()`, `utils::browseURL()` and reader
functions such as `read.csv()`.

``` r
"maurolepore/tor/inst/extdata/csv" %>% 
  ghr_ls_download_url() %>% 
  print() %>% 
  map(~ read.csv(.x, stringsAsFactors = FALSE))
#> [1] "https://raw.githubusercontent.com/maurolepore/tor/master/inst/extdata/csv/csv1.csv"
#> [2] "https://raw.githubusercontent.com/maurolepore/tor/master/inst/extdata/csv/csv2.csv"
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
  ghr_ls_html_url()

if (interactive()) {
  html_urls %>% 
    map(~ browseURL(.x))
}
```

You can pass additional arguments to `gh::gh()` via `...`, for example,
if you need more items than fit in the default `.limit` per page.

``` r
# Default number of items per page is 30
length(ghr_ls("maurolepore"))
#> [1] 30
# All repos in of the user maurolepore
length(ghr_ls("maurolepore", .limit = Inf))
#> [1] 101
```

You can request information from a specific branch via the argument
`ref` or with a `path` structured like this: `owner/repo/subdir@branch`

``` r
ghr_show_branches("maurolepore/ghr")
#> [1] "gh-pages" "master"

ghr_ls("maurolepore/ghr", ref = "gh-pages")
#>  [1] "CHANGELOG.html"       "CODE_OF_CONDUCT.html" "CONTRIBUTING.html"   
#>  [4] "ISSUE_TEMPLATE.html"  "LICENSE.html"         "SUPPORT.html"        
#>  [7] "articles"             "authors.html"         "docsearch.css"       
#> [10] "docsearch.js"         "index.html"           "link.svg"            
#> [13] "news"                 "pkgdown.css"          "pkgdown.js"          
#> [16] "pkgdown.yml"          "reference"
# Same
ghr_ls("maurolepore/ghr@gh-pages")
#>  [1] "CHANGELOG.html"       "CODE_OF_CONDUCT.html" "CONTRIBUTING.html"   
#>  [4] "ISSUE_TEMPLATE.html"  "LICENSE.html"         "SUPPORT.html"        
#>  [7] "articles"             "authors.html"         "docsearch.css"       
#> [10] "docsearch.js"         "index.html"           "link.svg"            
#> [13] "news"                 "pkgdown.css"          "pkgdown.js"          
#> [16] "pkgdown.yml"          "reference"
```

-----

## Information

  - [Getting help](SUPPORT.md).
  - [Contributing](CONTRIBUTING.md).
  - [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

## Acknowledgments

Thanks to Gábor Csárdi et. al for the [gh
package](https://github.com/maurolepore/ghr) and to Francois Michonneau,
James Balamuta, Noam Ross and Bryce Mecum for sharing their ideas and
code.
