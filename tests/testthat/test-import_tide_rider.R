test_that("Importing tide rider data works", {

  # This test is associated with import_tide_rider() but
  # is testing the entire workflow

  a <- local_example_dir(year_filter = 2025, site_filter = "TRS102", delete_old = TRUE)

  paths <- lookup_paths(deployment_dir = a$deployment)
  suppressWarnings(qc_deployment(paths$deployment_dir))

  expect_true(file.exists(paths$deployment_prelim_qc))
  expect_true(file.exists(paths$deployment_report))

  # Fake someone reviewing
  d <- readr::read_csv(paths$deployment_prelim_qc, show_col_types = FALSE)
  d$Date_Time <- as.character(d$Date_Time)
  d$Gen_QC[d$Gen_QC == 9999] <- 9
  readr::write_csv(d, paths$deployment_final_qc)

  expect_no_error(stitch_site(paths$site_dir))

  expect_no_error(report_site(site_dir = paths$site_dir, baywatchers = FALSE))

  csv <- list.files(file.path(paths$site_dir, "combined"), full.names = TRUE, pattern = "archive.*\\.csv$")

  d <- readr::read_csv(csv, show_col_types = FALSE)

  # Check to make sure we have real and varying Lat, Lon, and Depth
  diff <- function(r) r[2] - r[1]
  lat_diff <- range(d$Latitude, na.rm = TRUE) |> diff()
  expect_true(lat_diff > 0)
  lon_diff <- range(d$Longitude, na.rm = TRUE) |> diff()
  expect_true(lon_diff > 0)
  depth_diff <- range(d$Depth, na.rm = TRUE) |> diff()
  expect_true(depth_diff > 0)


})
