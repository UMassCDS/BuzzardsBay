test_that("apply_timezone works with character input", {
  dt <- "2024-10-28 23:25:01"
  res1 <- apply_timezone(dt, "GMT-4:00") |> lubridate::with_tz("UTC")
  res2 <- apply_timezone(dt, "EDT") |> lubridate::with_tz("UTC")
  expect_equal(res1, res2)

  # nolint start: line_length_linter
  # NOte ETC/GMT timezone offsets exist but they are reversed
  # So GMT -4 is "ETC/GMT+4".
  # See
  # https://stackoverflow.com/questions/53076575/time-zones-etc-gmt-why-it-is-other-way-round
  # And
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#Time_zone_abbreviations
  # nolint end
  res3 <- apply_timezone(dt, "ETC/GMT+4") |> lubridate::with_tz("UTC")
  expect_equal(res1, res3)
})


test_that("apply_timezone works with date-time input", {

  # Note the line below uses EDT but lubridate assumes UTC
  # So it is not correctly located in time.
  # But it works well for plotting with ggplot and plotly
  dt <- "2024-10-28 23:25:01" |> lubridate::as_datetime()


  res1 <- apply_timezone(dt, "GMT-4:00") |> lubridate::with_tz("UTC")
  res2 <- apply_timezone(dt, "EDT") |> lubridate::with_tz("UTC")
  expect_equal(res1, res2)

})
