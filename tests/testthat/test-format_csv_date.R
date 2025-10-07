test_that("format_csv_date_time( ) works at midnight with character output", {
  x <- c("8/6/2024 23:50", "8/7/2024 0:00", "8/7/2024 0:10", "8/7/2024 0:20")


  result <- format_csv_date_time(x, format = "character")
  expected_result <- c("2024-08-06 23:50:00",
                       "2024-08-07 00:00:00",
                       "2024-08-07 00:10:00",
                       "2024-08-07 00:20:00")

  expect_equal(result, expected_result)

  # test with other input format
  result2 <-  format_csv_date_time(result, format = "character")
  expect_equal(result2, expected_result)

})


test_that("format_csv_date_time( ) treats dates without times as midnight", {

  # This is how date times appear in the excel file created during hoboware
  # calibration of MX801 data. I'm not sure if it's hoboware, excel, or
  # R but midnight ends up without the date-time
  x <- c("2025-05-27 23:50:00", "2025-05-28", "2025-05-28 00:10:00")

  result <- format_csv_date_time(x, format = "character")
  expected_result <- c("2025-05-27 23:50:00",
                       "2025-05-28 00:00:00",
                       "2025-05-28 00:10:00"
  )

  expect_equal(result, expected_result)

  # test with mdy without times at midnight
  x2 <- c("05/27/2025 23:50:00", "05/27/2025", "05/28/2025 00:10:00")

  result2 <-  format_csv_date_time(result, format = "character")
  expect_equal(result2, expected_result)

})

