test_that("qc_deployment() works", {

  paths <- local_example_dir(year_filter = 2023)
  expect_no_error(d <- qc_deployment(paths$deployment))

})


test_that("qc_deployment() works with repeated High Range in column name", {
  # The BD1 conductivity data is coming out of hoboware with repeated
  # "High Range" in the name.
  # The .csv header line looks like this:
  # Date Time,High Range High Range (μS/cm),
  # Temp (°C)  #21095959,Specific Conductance (μS/cm),Salinity (ppt)

  paths <- local_example_dir(site_filter = "BD1",
                             deployment_filter = "2024-06-21")
  deployment <- paths$deployment
  files <- list.files(deployment, recursive = TRUE, full.names = TRUE)
  cond_path <- grep("_Cond_.*_Details.txt", files, value = TRUE)
  do_path <- grep("_DO_.*_Details.txt", files, value = TRUE)

  expect_no_error(qc_deployment(deployment))

})


test_that("qc_deployment() works after a sensor has been swapped out", {

  #  OB1 2024-05-21, 2024-05-31
  paths <- local_example_dir(site_filter = "OB1",
                             deployment_filter = "2024-05-21")

  deployment  <- paths$deployment
  placements_path <- file.path(paths$base, "2024", "Metadata", "placements.csv")
  placements <- readr::read_csv(placements_path)

  # Check 2024-05-21, last before swap
  sn <- 21415528

  expect_no_error(
    check_placement(sn, type = "Cond", placements, "2024-05-21", "OB1")
  )

  # Check 2024-05-31, after swap
  # Note header in this file is different than other 2024 files

  paths <- local_example_dir(site_filter = "OB1",
                             deployment_filter = "2024-05-31")

  deployment  <- paths$deployment
  placements_path <- file.path(paths$base, "2024", "Metadata", "placements.csv")
  placements <- readr::read_csv(placements_path)


  sn <- 20882470
  expect_no_error(
    check_placement(sn, type = "Cond", placements, "2024-05-21", "OB1")
  )

  qc_deployment(deployment)

})


test_that("qc_deployment() works with a preceeding deployment", {

  paths <- local_example_dir(site_filter = "OB1")


  # Process "prior" deployment to make data for it
  suppressWarnings(qc_deployment(paths$deployments[1]))

  # Process current deployment - plots should include prior
  expect_no_error(qc_deployment(paths$deployments[2]))

})

test_that("qc_deploytment() date time bug is fixed", {
  paths <- local_example_dir(site_filter = "BD1", year_filter = 2024)
  deployment <- paths$deployments[grep("2024-09-23", paths$deployments)]
  expect_no_error(qc_deployment(deployment))
})
