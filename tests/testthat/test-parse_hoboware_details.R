test_that("get_cond_details() works with single point conductivity calibration", {
  paths <- local_example_dir()
  deployments <- paths$deployments
  deployment <- grep("SB2X/2024-05-15", deployments, value = TRUE)
  files <- list.files(deployment, recursive = TRUE, full.names = TRUE)
  cond_path <- grep("_Cond_.*_Details.txt", files, value = TRUE) # to Cond Details
  do_path <- grep("_DO_.*_Details.txt", files, value = TRUE)
  expect_no_error(get_cond_details(cond_path))
  qc_deployment(deployment)

})


test_that("get_cond_details() works with repeated High Range in column name", {
  # The BD1 conductivity data is coming out of hoboware with repeated
  # "High Range" in the name.
  # The .csv header line looks like this:
  # Date Time,High Range High Range (μS/cm),Temp (°C)  #21095959,Specific Conductance (μS/cm),Salinity (ppt)


  paths <- local_example_dir()
  deployments <- paths$deployments
  deployment <- grep("BD1/2024-06-21", deployments, value = TRUE)
  files <- list.files(deployment, recursive = TRUE, full.names = TRUE)
  cond_path <- grep("_Cond_.*_Details.txt", files, value = TRUE) # to Cond Details
  do_path <- grep("_DO_.*_Details.txt", files, value = TRUE)

  qc_deployment(deployment)

})


