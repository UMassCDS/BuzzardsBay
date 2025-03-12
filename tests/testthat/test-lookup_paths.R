test_that("lookup_paths() is consistent and complete", {

  example_paths <- local_example_dir(year_filter = 2023, site_filter = "RB1")
  deployment_dir <- example_paths$deployment


  make_relative <- function(x) {
    base_pattern <- paste0("^", x$base_dir, "[/\\]*")
    strip_one <- function(x) gsub(base_pattern, "", x)
    res <- lapply(x, strip_one) |>
      lapply(function(x) gsub("\\\\", "/", x))
    return(res)
  }

  # Full set of paths from deployment_dir argument
  expect_no_error(paths_1 <- lookup_paths(deployment_dir = deployment_dir))

  # Verify that relative links are consistent
  rel_1 <- paths_1 |> make_relative() |> yaml::as.yaml()
  expect_snapshot(cat(rel_1))

  # Using base_dir, year, site
  expect_no_error(paths_2 <- lookup_paths(base_dir = paths_1$base_dir,
                                          site = paths_1$site,
                                          year = paths_1$year))

  site_elements <- c("base_dir",
                     "year_dir",
                     "site_dir",
                     "md_dir",  # year spec
                     "preceding_auto_qc",
                     "sites",
                     "placements",
                     "import_types",
                     "global_parameters",
                     "site_parameters",
                     "year",
                     "site")
  site_na_elements <- setdiff(names(paths_1), site_elements)

  expect_equal(paths_2[site_elements], paths_1[site_elements])
  expect_true(all(is.na(paths_2[site_na_elements])))

  # Using base_dir, year
  expect_no_error(paths_3 <- lookup_paths(base_dir = paths_1$base_dir,
                                          year = paths_1$year))
  year_elements <- c("base_dir",
                     "year_dir",
                     "md_dir",  # year spec
                     "sites",
                     "placements",
                     "import_types",
                     "global_parameters",
                     "year")
  year_na_elements <- setdiff(names(paths_1), year_elements)
  expect_equal(paths_3[year_elements], paths_1[year_elements])
  expect_true(all(is.na(paths_3[year_na_elements])))

  # base_dir only
  expect_no_error(paths_4 <- lookup_paths(base_dir = paths_1$base_dir))
  base_elements <- c("base_dir",
                     "global_parameters")
  base_na_elements <- setdiff(names(paths_1), base_elements)
  expect_equal(paths_4[base_elements], paths_1[base_elements])
  expect_true(all(is.na(paths_4[base_na_elements])))

})
