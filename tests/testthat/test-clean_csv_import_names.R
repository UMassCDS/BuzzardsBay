
test_that("clean_csv_import_names() works with MX801 column names", {

  # nolint start: indentation_linter
  mx801_example_file <-  system.file(
     "extdata/2025/BBC/2025-01-04/Calibrated/BBC_MX2_22145899_2025-01-04.xlsx",
    package = "BuzzardsBay")
  # nolint end
  d <- readxl::read_excel(mx801_example_file, 1)

  expect_no_error(clean <- clean_csv_import_names(d))

  expected_cols <- get_expected_columns("calibrated", names(clean))

  miss <- setdiff(expected_cols, c(names(clean), "Salinity_DOLog"))
  expect_length(miss, 0)
})

test_that("clean_csv_import_names() works with older logger names", {
  # nolint start: indentation_linter
  cond_example_file <- system.file(
    "extdata/2024/OB1/2024-05-21/Calibrated/OB1_Cond_KHCal_2024_05_21.csv",
    package = "BuzzardsBay")

  do_example_file <- system.file(
    "extdata/2024/OB1/2024-05-21/Calibrated/OB1_DO_KHCal_2024_05_21.csv",
    package = "BuzzardsBay")
  # nolint end
  cond <- readr::read_csv(cond_example_file, show_col_types = FALSE)
  names(cond)[grep("^Temp", names(cond))] <- "Temp_CondLog"

  do <- readr::read_csv(do_example_file, show_col_types = FALSE) |>
    dplyr::rename(Salinity_DOLog = "Salinity (ppt)")
  names(do)[grep("^Temp", names(do))] <- "Temp_DOLog"


  d <- dplyr::full_join(do, cond, by = "Date Time")

  clean <- clean_csv_import_names(d)
  expected_cols <- get_expected_columns("calibrated", names(clean))

  miss <- setdiff(expected_cols, names(clean))
  expect_length(miss, 0)


})


test_that("clean_csv_import_names() works with canonical names", {
  qc_file <- system.file("extdata/2024/AB2/2024-08-16/QC_AB2_2024-08-16.csv",
                         package = "BuzzardsBay")
  d <- readr::read_csv(qc_file, show_col_types = FALSE)
  expected <- setdiff(get_expected_columns("calibrated", names(d)),
                      "Salinity_DOLog")
  d <- d[, expected]

  clean <- clean_csv_import_names(d)
  # Cleaning the names shouldn't change any of the canonical names
  expect_true(all(names(d) == names(clean)))
})
