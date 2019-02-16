context("gh_ls")

# mock start ----------------------------------------------------------------
gh_ls2 <- function(path) {
  n <- length(split_url(path))
  if (n == 1L) {
    out <- ls_owner2(owner = owner(path))
  } else if (n == 2L) {
    out <- ls_repo2(repo = owner_repo(path))
  } else if (n >= 3L) {
    out <- ls_content2(repo = owner_repo(path), subdir = subdir(path))
  } else {
    stop("Bad request", call. = FALSE)
  }
  out
}

ls_request2 <- function(request) {
  request
}

ls_owner2 <- function(owner) {
  ls_request2(glue::glue("/users/{owner}/repos"))
}

ls_repo2 <- function(repo) {
  ls_request2(glue::glue("/repos/{repo}/contents/"))
}

ls_content2 <- function(repo, subdir = NULL) {
  ls_request2(glue::glue("/repos/{repo}/contents/{subdir}"))
}

testthat::expect_equal(
  gh_ls2("forestgeo"), "/users/forestgeo/repos"
)
testthat::expect_equal(
  gh_ls2("forestgeo/fgeo"), "/repos/forestgeo/fgeo/contents/"
)
testthat::expect_equal(
  gh_ls2("forestgeo/fgeo/sub1"), "/repos/forestgeo/fgeo/contents/sub1"
)
testthat::expect_equal(
  gh_ls2("forestgeo/fgeo/sub1/sub2"), "/repos/forestgeo/fgeo/contents/sub1/sub2"
)

# Helpers
testthat::expect_equal(split_url("owner/repo"), c("owner", "repo"))

testthat::expect_equal(owner("owner/repo"), "owner")
testthat::expect_equal(owner("owner"), "owner")

testthat::expect_equal(repo("owner/repo"), "repo")
testthat::expect_error(repo("owner"), "out of bounds")

testthat::expect_equal(owner_repo("owner/repo"), "owner/repo")
testthat::expect_error(owner_repo("owner"), "out of bounds")

testthat::expect_equal(subdir("owner/repo/sub1/sub2"), "sub1/sub2")
testthat::expect_error(subdir("owner/repo"), "length.*>= 3 is not TRUE")

# mock end ----------------------------------------------------------------
