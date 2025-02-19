test_that("qc_deployment() works", {

  example_paths <- local_example_dir(year_filter = 2023)
  expect_no_error(l <- qc_deployment(example_paths$deployment))

  paths <- lookup_paths(deployment_dir  = example_paths$deployment)

  expect_true(all(label = file.exists(paths$deployment_auto_qc,
                                      paths$deployment_prelim_qc,
                                      paths$deployment_report)))
  d <- readr::read_csv(paths$deployment_auto_qc, show_col_types = FALSE)

  # Check that column names are as expected
  expect_equal(names(d), get_expected_columns("qc_final", names(d)))

  # Check that the location and flags of the first 20 flags haven't changed
  flags <- data.frame(row = seq_len(nrow(d)), Flags = d$Flags) |>
    dplyr::filter(!is.na(Flags)) |>
    head(n = 20)
  expect_snapshot(flags)

  # Check that rows 50 to 53 have not changed
  expect_snapshot(d[50:53, ] |> as.data.frame())


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

  if (FALSE) {
    # This line useful for debugging
    make_deployment_report(example_paths$deployments[2])
  }
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


test_that("man/qc_deployment() works with MX801 data", {

  example_paths <- local_example_dir(site_filter = "BBC",
                                     year_filter = 2025, subdir = "mx801")
  deployment_dirs <- example_paths$deployments

  #----------------------------------------------------------------------------#
  # File with 2 point DO, and 2 point Condudctivity calibration
  #----------------------------------------------------------------------------#
  n_do  <- 2
  n_cond <- 2
  paths1 <- lookup_paths(deployment_dir = deployment_dirs[1])
  expect_no_error(res1 <- qc_deployment(paths1$deployment_dir))
  expect_true("Depth" %in% names(res1$d))

  #n do
  expect_equal(res1$md$do_calibration$n_points, n_do)
  expect_length(res1$md$do_calibration$pct_saturation, n_do)
  expect_length(res1$md$do_calibration$measured_do, n_do)

  # n Cond
  expect_length(res1$md$cond_calibration$spec_cond_25c, n_cond)
  expect_length(res1$md$cond_calibration$measured_cond, n_cond)
  expect_length(res1$md$cond_calibration$temperature, n_cond)

  #----------------------------------------------------------------------------#
  # File with 2 point DO and 3 point Conductivity calibration
  #----------------------------------------------------------------------------#
  n_do <- 2
  n_cond <- 3
  paths2 <- lookup_paths(deployment_dir = deployment_dirs[2])
  expect_no_error(res2 <- qc_deployment(paths2$deployment_dir))
  expect_true("Depth" %in% names(res2$d))

  #n do
  expect_equal(res2$md$do_calibration$n_points, n_do)
  expect_length(res2$md$do_calibration$pct_saturation, n_do)
  expect_length(res2$md$do_calibration$measured_do, n_do)

  # n Cond
  expect_length(res2$md$cond_calibration$spec_cond_25c, n_cond)
  expect_length(res2$md$cond_calibration$measured_cond, n_cond)
  expect_length(res2$md$cond_calibration$temperature, n_cond)

  #----------------------------------------------------------------------------#
  # File with 1 point DO and 2 point Conductivity calibration
  #----------------------------------------------------------------------------#
  n_do  <- 1
  n_cond <- 2

  paths3 <-  lookup_paths(deployment_dir = deployment_dirs[3])
  expect_no_error(res3 <- qc_deployment(paths3$deployment_dir))

  expect_true("Depth" %in% names(res3$d))

  #n do
  expect_equal(res3$md$do_calibration$n_points, n_do)
  expect_length(res3$md$do_calibration$pct_saturation, n_do)
  expect_length(res3$md$do_calibration$measured_do, n_do)

  # n Cond
  expect_length(res3$md$cond_calibration$spec_cond_25c, n_cond)
  expect_length(res3$md$cond_calibration$measured_cond, n_cond)
  expect_length(res3$md$cond_calibration$temperature, n_cond)

})
