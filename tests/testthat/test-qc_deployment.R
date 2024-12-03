test_that("qc_deployment() works", {

  example_paths <- local_example_dir(year_filter = 2023)
  expect_no_error(l <- qc_deployment(example_paths$deployment))

  paths <- lookup_paths(deployment_dir  = example_paths$deployment)

  expect_true(all(label = file.exists(paths$deployment_auto_qc,
                                      paths$deployment_prelim_qc,
                                      paths$deployment_report)))
  d <- readr::read_csv(paths$deployment_auto_qc, show_col_types = FALSE)
  expect_equal(names(d), expected_column_names$qc_final)

  expect_snapshot(head(d) |> as.data.frame())

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
  placements <- read_and_format_placements(placements_path)

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
  placements <- read_and_format_placements(placements_path)


  sn <- 20882470
  expect_no_error(
    check_placement(sn, type = "Cond", placements, "2024-05-21", "OB1")
  )

  qc_deployment(deployment)

})


test_that("qc_deployment() works with a preceeding deployment", {

  # Data from previous deployment is incorporated into report

  example_paths <- local_example_dir(site_filter = "OB1")

  paths <- lookup_paths(deployment_dir =
                          example_paths$deployment)

  # Process "prior" deployment to make data for it
  suppressWarnings(qc_deployment(example_paths$deployments[1], report = FALSE))

  # Process current deployment - plots should include prior
  expect_no_error(qc_deployment(example_paths$deployments[2]))

  make_deployment_report(example_paths$deployments[2])

})

test_that("qc_deployment() date time bug is fixed", {
  paths <- local_example_dir(site_filter = "BD1", year_filter = 2024)
  deployment <- paths$deployments[grep("2024-09-23", paths$deployments)]
  expect_no_error(qc_deployment(deployment))
})

test_that("qc_deployment() plot range with error codes in data", {
  # The sensors record -888.88 when there is an error we
  # don't want this to affect plotting.
  example_paths <- local_example_dir(site_filter = "OB9",
                                     deployment_filter = "2024-07-23")

  paths <- lookup_paths(deployment_dir = example_paths$deployment)
  expect_no_error(qc_deployment(example_paths$deployment))

})


test_that("qc_deployment() works with fixed salinity calibration", {
  example_paths <- local_example_dir(site_filter = "OB1",
                                     deployment_filter = "2024-07-30")
  paths <- lookup_paths(deployment_dir = example_paths$deployment)
  expect_no_error(qc_deployment(example_paths$deployment))
})
