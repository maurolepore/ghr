html_url <- purrr::map_chr(gh::gh(gh_path("forestgeo/fgeo.x/data")), "html_url")
tmp <- tempfile()
download.file(html_url[[1]], tmp)



html_url <- purrr::map_chr(gh::gh(gh_path("forestgeo/fgeo")), "html_url")
fs::path_file(html_url)



purrr::map_chr(gh::gh("/users/forestgeo/repos"), "name")
purrr::map_chr(gh::gh(gh_path("forestgeo")), "name")

purrr::map_chr(gh::gh(gh_path("forestgeo/fgeo")), "name")
purrr::map_chr(gh::gh("/repos/forestgeo/fgeo/contents"), "name")

purrr::map_chr(gh::gh(gh_path("forestgeo/fgeo/R")), "name")
purrr::map_chr(gh::gh("/repos/forestgeo/fgeo/contents/R"), "name")

purrr::map_chr(gh::gh("/repos/forestgeo/fgeo/contents/tests"), "name")
purrr::map_chr(gh::gh("/repos/forestgeo/fgeo/contents/tests/testthat"), "name")

