
# Import type  0 -- CSV

test_that("qc_deployment() works with import type 0 (simple CSV)", {
  example_paths <- local_example_dir(site_filter = "SIM",
                                     year_filter = 2025)
  deployment_dir <- example_paths$deployment
  paths <- lookup_paths(deployment_dir = deployment_dir)
  expect_no_error(qc_deployment(deployment_dir))

  d <- readr::read_csv(paths$deployment_auto_qc, n_max = 100)
  col_spec <- spec(d)
  col_spec$cols$Date_Time <- readr::col_character()
  d2 <- readr::read_csv(paths$deployment_auto_qc, col_types = col_spec,
                        n_max = 100)


  expect_snapshot(as.data.frame(d2) |> head(2))

  expect_equal(d2$Date_Time[1], "2025-01-02 14:50:02")

})

# Import type 1 -- U24 and U26

test_that("qc_deployment() works with U24 and U26 loggers", {

  # RB1 2023-06-09

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
  # Temp (°C)  #21095959,Specific Conductance (μS/cm),Salinity (ppt) # nolint

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

test_that("qc_deployment()  MX801 date time bug is fixed", {
  # Added 2025-10-07 for OB1 2025-07-31
  example_paths <- local_example_dir(site_filter = "OB1", year_filter = 2025)
  deployment <- example_paths$deployment
  expect_no_error(qc_deployment(deployment))

  paths <- lookup_paths(deployment_dir = deployment)

  # Read in result with auto column detection
  d <- readr::read_csv(paths$deployment_prelim_qc)

  # Read it in again with character Date_Times
  spec <- readr::spec(d)
  spec$cols$Date_Time <- col_character()
  d2 <- readr::read_csv(paths$deployment_prelim_qc, col_types = spec)

  # Check that first midnight is correct
  expect_equal(d2$Date_Time[50], "2025-07-25 00:00:00")

  #  3 row snap shot that includes midnight
  expect_snapshot(d2[49:51, ] |> as.data.frame())

})


test_that("qc_deployment() plot range with error codes in data", {
  # The sensors record -888.88 when there is an error we
  # don't want this to affect plotting.
  example_paths <- local_example_dir(site_filter = "OB9",
                                     deployment_filter = "2024-07-23")

  expect_no_error(qc_deployment(example_paths$deployment))

})


test_that("qc_deployment() works with fixed salinity calibration", {
  example_paths <- local_example_dir(site_filter = "OB1",
                                     deployment_filter = "2024-07-30")
  paths <- lookup_paths(deployment_dir = example_paths$deployment)
  expect_no_error(qc_deployment(example_paths$deployment))
})

test_that("man/qc_deployment() works with MX801 data and yaml file", {


  example_paths <- local_example_dir(site_filter = "BBC",
                                     year_filter = 2025,
                                     deployment_filter = "2025-01-04",
                                     subdir = "mx801")
  deployment_dir <- example_paths$deployments[1]
  paths <- lookup_paths(deployment_dir = deployment_dir)

  expect_no_error(qc_deployment(deployment_dir))

})


# Import type 2  -- MX801


test_that("qc_deployment() works with MX801 data", {

  #   * 2025-01-04 (2, 2) - two point calibration for both DO and Cond.
  #    calibration. I think this is the most common type.
  #   * 2025-01-06 (2, 3)- two points for DO and three points for Cond. cal.
  #   * 2025-01-27 (2, 1) - one point for DO and two points for Cond. cal.
  # Note I'm no longer parsing the details sheet which is what most of this
  # test is about so am skipping a lot of it.  Leaving code here in case we
  # ever decide to revert to parsing the details sheet.


  example_paths <- local_example_dir(site_filter = "BBC",
                                     year_filter = 2025, subdir = "mx801")
  deployment_dirs <- example_paths$deployments

  #----------------------------------------------------------------------------#
  # File with 2 point DO, and 2 point Condudctivity calibration
  #----------------------------------------------------------------------------#
  n_do  <- 2
  n_cond <- 2
  ddir1 <- grep("2025-01-04", deployment_dirs, value = TRUE)
  paths1 <- lookup_paths(deployment_dir = ddir1)
  expect_no_failure(res1 <- qc_deployment(paths1$deployment_dir))
  expect_true("Depth" %in% names(res1$d))

  skip(paste0("Legacy tests to verify parsing of MX801 details",
       "- always skipped"))
  # The difference among these files was the details tab which needed to handle
  # variations in format depending on how many calibration points were used.
  # We have since stopped parsing the deails and instead are using a yaml file
  # so users can set the window.

  #----------------------------------------------------------------------------#
  # File with 2 point DO and 3 point Conductivity calibration
  #----------------------------------------------------------------------------#
  n_do <- 2
  n_cond <- 3
  paths2 <- lookup_paths(deployment_dir = deployment_dirs[2])
  expect_no_error(res2 <- qc_deployment(paths2$deployment_dir))
  expect_true("Depth" %in% names(res2$d))


  #----------------------------------------------------------------------------#
  # File with 1 point DO and 2 point Conductivity calibration
  #----------------------------------------------------------------------------#
  n_do  <- 1
  n_cond <- 2

  paths3 <-  lookup_paths(deployment_dir = deployment_dirs[3])
  expect_no_error(res3 <- qc_deployment(paths3$deployment_dir))

  expect_true("Depth" %in% names(res3$d))

  #----------------------------------------------------------------------------#
  #  Input file with different internal line endings
  #----------------------------------------------------------------------------#
  skip("Skipping extra MX801 test - always skipped.")
  paths4 <-  lookup_paths(deployment_dir = deployment_dirs[4])
  expect_no_error(res4 <- qc_deployment(paths4$deployment_dir))


})




# Test specific flags -- uses import type 0

test_that("man/qc_deployment() checks specific flags", {

  # There's a lot of overhead here to make a test file
  # I'm setting up to use the simple csv import on  the example data
  # from an MX801 logger.
  # Editing the data to make specific combinations of too deep and out of water
  # against other immediate rejection and review flags and then
  # writing as a CSV before processing with the simple import.


  site <- "BBC"
  example_paths <- local_example_dir(site_filter = site,
                                     year_filter = 2025, subdir = "mx801")
  deployment_dir <- example_paths$deployment

  paths <- lookup_paths(deployment_dir = deployment_dir)

  calibrated_file <- list.files(paths$deployment_cal_dir,
                                pattern = "xlsx", full.names = TRUE)
  md_file <-  list.files(paths$deployment_cal_dir,
                         pattern = "yml$", full.names = TRUE)
  expect_length(calibrated_file, 1)


  # REformat metadata from mx801 to CSV import style
  md <- read_deployment_yaml(md_file, mx801 = TRUE)
  file.remove(md_file)
  yaml::write_yaml(md, md_file)


  # Reformat data -- adding issues
  d <- readxl::read_excel(calibrated_file, sheet = 1)

  sites <- readr::read_csv(paths$sites, show_col_types = FALSE)
  max_depth <- bb_options("max_depth")
  depth_col <- grep("Water Level", names(d), value = TRUE)

  # Add fake too deep
  too_deep  <- rep(FALSE, nrow(d))
  too_deep[21:24] <- TRUE
  d[too_deep, depth_col] <- max_depth + 1
  d[[depth_col]][!too_deep & d[[depth_col]] > max_depth] <-
    max_depth - 1  # not too deep elsewhere

  # Add fake not wet (AKA out of water)
  min_depth <- bb_options("min_depth")
  not_wet  <- rep(FALSE, nrow(d))
  not_wet[31:34] <- TRUE
  d[not_wet, depth_col] <- min_depth - 1 # fake not wet
  d[[depth_col]][!not_wet & d[[depth_col]] < min_depth] <-
    min_depth  + 1  # wet everywhere else

  # hack temperature so it doesn't throw flags
  # Note these column names are specific to this exact file
  temp_do_col <- grep("Temperature.*DO", names(d), value = TRUE)
  temp_cond_col <- grep("Temperature.*CTD", names(d), value = TRUE)

  d[[temp_cond_col]] <- 20
  d[[temp_do_col]] <- 20

  # Trigger immediate rejection flags
  immediate_rejection <- rep(FALSE, nrow(d))
  immediate_rejection[c(23, 24, 33, 34)] <- TRUE
  col <- grep("^Measured DO", names(d), value = TRUE)
  d[immediate_rejection, col] <-
    bb_options("logger_error_values")

  # Trigger review flags
  review <- rep(FALSE, nrow(d))
  review[c(22, 23, 32, 33)] <- TRUE
  d[[temp_cond_col]][review] <-
    sites$Min_QC_Temp[sites$site == site] - 0.5 # Flag will be "TCsl"


  original_dates <- d$`Date-Time (EST)` |> as.character()

  # Write new example data in the CSV / YAML formats
  csv <- file.path(paths$deployment_cal_dir, "MX801_calibrated.csv")
  readr::write_csv(d, csv)
  file.remove(calibrated_file) #  delete old excel file

  # Update placements so that it will be read as csv not xlsx
  placements <- readr::read_csv(paths$placements, show_col_types = FALSE)
  sv <- placements$site == paths$site &
    placements$SN == md$do_device$serial_number
  placements$model[sv] <- "MX801-CSV"
  readr::write_csv(placements, paths$placements)

  # DONE SETUP



  # TEST
  expect_warning(res <- qc_deployment(deployment_dir),
                 regexp = "lower than the warning threshold")
  d <- res$d
  md <- res$md



  # update flags to account for trimmed dates
  retained <- original_dates %in% d$Date_Time
  for(flag in c("too_deep", "not_wet", "review", "immediate_rejection"))
    assign(flag, value = get(flag)[retained])



  expect_true(all(d$Depth_QC[too_deep] == 7))
  expect_true(all(grepl("Wh", d$Flags[too_deep])))

  expect_true(all(d$Depth_QC[not_wet] == 7))
  expect_true(all(grepl("Wl", d$Flags[not_wet])))

  # Flag interactions in Gen_Qc
  # A 91 from depth overwrites a 9 from other flags
  # A 91 from depth does not overwrite a 9999 from other flags
  # A 9999 from depth does not overwrite a 9 from other flags.
  # A 91 or 9999 from depth overwrites NA from other flags.
  expect_true(all(d$Gen_QC[not_wet & immediate_rejection] %in% 91))
  expect_true(all(d$Gen_QC[not_wet & !immediate_rejection & review] %in% 9999))
  expect_true(all(d$Gen_QC[too_deep & !immediate_rejection] %in% 9999))
  expect_true(all(d$Gen_QC[review & !immediate_rejection & !not_wet] %in% 9999))

  sel_cols <- c("Gen_QC", "Flags", "Depth", "Depth_QC")
  sel_rows <- too_deep | not_wet | immediate_rejection | review

  expect_snapshot(d[sel_rows, sel_cols])

})




