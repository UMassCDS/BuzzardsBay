test_that("parse_mx801_details() works", {

  skip("No longer parsing MX801 details - legacy code")

  example_paths <- local_example_dir(site_filter = "BBC",
                                     year_filter = 2025)

  deployment_dirs <- example_paths$deployments

  # Test with different types of calibration

  paths <- lookup_paths(deployment_dir = deployment_dirs[1])
  f <- list.files(paths$deployment_cal_dir, full.names = TRUE,
                  pattern = ".xlsx")
  expect_no_error(md <- parse_mx801_details(f))
  expect_snapshot(yaml::as.yaml(md))

  paths <- lookup_paths(deployment_dir = deployment_dirs[2])
  f <- list.files(paths$deployment_cal_dir, full.names = TRUE,
                  pattern = ".xlsx")
  expect_no_error(md <- parse_mx801_details(f))

  paths <- lookup_paths(deployment_dir = deployment_dirs[3])
  f <- list.files(paths$deployment_cal_dir, full.names = TRUE,
                  pattern = ".xlsx")
  expect_no_error(md <- parse_mx801_details(f))

  paths <- lookup_paths(deployment_dir = deployment_dirs[4])
  f <- list.files(paths$deployment_cal_dir, full.names = TRUE,
                  pattern = ".xlsx")
  expect_no_error(md4 <- parse_mx801_details(f))
  expect_snapshot(md4$do_calibration)



})
