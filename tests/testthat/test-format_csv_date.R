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
