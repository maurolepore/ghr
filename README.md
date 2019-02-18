
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

ghr helps you to get a GitHub-API response and to do common tasks. The
syntax for specfying a GitHb path is similar to that used in
`remotes::install_github()` and friends. For example, this is a valid
path `r-lib/usethis@master`. Also this one:
`r-lib/usethis/news@gh-pages`.

## Installation

``` r
install.packages("devtools")
devtools::install_github("maurolepore/ghr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(magrittr)
library(ghr)
```

Use `ghr_get()` to get a GitHub-API response. Notice that the call is
memoised.

``` r
system.time(ghr_get("r-lib/gh"))
#>    user  system elapsed 
#>    0.09    0.03    0.36
# Takes no time because the first call is memoised
system.time(ghr_get("r-lib/gh"))
#>    user  system elapsed 
#>       0       0       0
```

Use `ghr_fields()` to see what fields are available for a given `path`.

``` r
gh_response <- ghr_get(path = "r-lib/usethis/tests")
class(gh_response)
#> [1] "gh_response" "list"

ghr_fields(gh_response)
#>  [1] "name"         "path"         "sha"          "size"        
#>  [5] "url"          "html_url"     "git_url"      "download_url"
#>  [9] "type"         "_links"
```

Use `ghr_pull()` and its shortcuts to access specific fields of the
GitHub response.

``` r
ghr_pull(gh_response, "name")
#> [1] "manual"     "spelling.R" "testthat.R" "testthat"
```

The `path` argument to `ghr_get()` understands a syntax as
`owner/repo/path@branch`

``` r
ghr_branches("r-lib/usethis")
#>  [1] "clang-format"         "f-479-proj-path-prep" "gh-pages"            
#>  [4] "logo"                 "master-clean-start"   "master"              
#>  [7] "moar-version-menu"    "pkgdown-travis"       "pr-flow-upgrades"    
#> [10] "pr-pull-upstream"     "release-type"         "tidy-travis-matrix"

"r-lib/usethis/reference@gh-pages" %>% 
  ghr_get() %>% 
  ghr_pull("name")
#>  [1] "badges.html"                 "browse-this.html"           
#>  [3] "browse_github_pat.html"      "ci.html"                    
#>  [5] "create_from_github.html"     "create_package.html"        
#>  [7] "edit.html"                   "edit_file.html"             
#>  [9] "figures"                     "index.html"                 
#> [11] "licenses.html"               "proj_sitrep.html"           
#> [13] "proj_utils.html"             "tidyverse.html"             
#> [15] "use_blank_slate.html"        "use_build_ignore.html"      
#> [17] "use_code_of_conduct.html"    "use_course.html"            
#> [19] "use_course_details.html"     "use_coverage.html"          
#> [21] "use_cran_comments.html"      "use_data.html"              
#> [23] "use_description.html"        "use_directory.html"         
#> [25] "use_git.html"                "use_git_config.html"        
#> [27] "use_git_hook.html"           "use_git_ignore.html"        
#> [29] "use_github.html"             "use_github_labels.html"     
#> [31] "use_github_links.html"       "use_logo.html"              
#> [33] "use_namespace.html"          "use_news_md.html"           
#> [35] "use_package.html"            "use_package_doc.html"       
#> [37] "use_pipe.html"               "use_pkgdown.html"           
#> [39] "use_r.html"                  "use_rcpp.html"              
#> [41] "use_readme_rmd.html"         "use_revdep.html"            
#> [43] "use_rmarkdown_template.html" "use_roxygen_md.html"        
#> [45] "use_rstudio.html"            "use_spell_check.html"       
#> [47] "use_template.html"           "use_testthat.html"          
#> [49] "use_tibble.html"             "use_tidy_thanks.html"       
#> [51] "use_usethis.html"            "use_version.html"           
#> [53] "use_vignette.html"           "usethis-defunct.html"       
#> [55] "usethis-package.html"        "write-this.html"
```

There are some shortcuts to `ghr_pull()`:

``` r
"maurolepore/tor/inst/extdata/csv" %>% 
  ghr_get() %>% 
  ghr_download_url() %>%
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
  ghr_html_url()
html_urls
#> [1] "https://github.com/maurolepore/tor/blob/master/inst/extdata/csv/csv1.csv"
#> [2] "https://github.com/maurolepore/tor/blob/master/inst/extdata/csv/csv2.csv"

if (interactive()) {
  html_urls %>% 
    lapply(utils::browseURL)
}
```

## Acknowledgements

Thanks to Gábor Csárdi et. al for the [gh
package](https://github.com/r-lib/gh) and to Francois Michonneau, James
Balamuta, Noam Ross and Bryce Mecum for sharing their ideas and code.
