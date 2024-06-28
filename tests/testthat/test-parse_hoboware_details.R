test_that("get_cond_details() works with single point cond. calibration", {
  deployment <- local_example_dir(site_filter = "SB2X",
                                  deployment_filter = "2024-05-15")$deployment

  files <- list.files(deployment, recursive = TRUE, full.names = TRUE)
  cond_path <- grep("_Cond_.*_Details.txt", files, value = TRUE)
  do_path <- grep("_DO_.*_Details.txt", files, value = TRUE)
  expect_no_error(get_cond_details(cond_path))
  qc_deployment(deployment)

})
