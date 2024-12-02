test_that("plot_tide_sun() works", {
  site <- "W12A"

  d <- system.file("extdata/qc_example.csv", package = "BuzzardsBay") |>
    readr::read_csv(show_col_types = FALSE)

  sites <- system.file("extdata/sites.csv", package = "BuzzardsBay") |>
    readr::read_csv(show_col_types = FALSE)

  r <- which(sites$site == site)
  station <- sites$tide_station[r]
  lat <- sites$latitude[r]
  lon <- sites$longitude[r]
  tz <- "GMT-4:00"
  expect_no_error(is_daylight(d$Date_Time, lat, lon, tz))

  expect_no_error(plot_tide_sun(d = d, station, lat = lat, lon = lon, tz))


})
