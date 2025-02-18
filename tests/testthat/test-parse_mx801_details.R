test_that("parse_mx801_details() works", {

  example_paths <- local_example_dir(site_filter = "BBC",
                                     year_filter = 2025)

  deployment_dirs <- example_paths$deployments

  # Test with different types of calibration

  paths <- lookup_paths(deployment_dir = deployment_dirs[1])
  f <- list.files(paths$deployment_cal_dir, full.names = TRUE)
  expect_no_error(md <- parse_mx801_details(f))
  expect_snapshot(yaml::as.yaml(md))

  paths <- lookup_paths(deployment_dir = deployment_dirs[2])
  f <- list.files(paths$deployment_cal_dir, full.names = TRUE)
  expect_no_error(md <- parse_mx801_details(f))


  paths <- lookup_paths(deployment_dir = deployment_dirs[3])
  f <- list.files(paths$deployment_cal_dir, full.names = TRUE)
  expect_no_error(md <- parse_mx801_details(f))



})
