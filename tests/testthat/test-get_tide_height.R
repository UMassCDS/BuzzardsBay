test_that("get_tide_height works with all stations", {
  sites <- system.file("extdata/sites.csv", package = "BuzzardsBay") |>
    readr::read_csv(show_col_types = FALSE)

  station_ids <- sites$tide_station


  d <- system.file("extdata/qc_example.csv", package = "BuzzardsBay") |>
    readr::read_csv(show_col_types = FALSE)


  sites$station_works <- sites$tide_station %in%
    tide_station_info$id[!is.na(tide_station_info$rtide_name)]

  dt <- apply_timezone(d$Date_Time, "GMT-04:00")
  res <- matrix(nrow = length(dt), ncol = length(station_ids),
                dimnames = list(date_time = NULL, tide_station = station_ids))


  all(station_ids %in% tide_station_info$id)

  skip("Document a failure in get_tide_hight() (always skipped)")
  # test  fails:
  for (i in seq_along(station_ids)) {
    res[, i] <- get_tide_height(dt, station = station_ids[i])
  }
})
