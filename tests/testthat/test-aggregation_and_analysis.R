
# NOTE: this should probably be renamed based on the function name we pick
# to do the aggregation and reporting.

# Example test code - for aggregation


test_that("Aggregation works", {

  skip() # Delete to run tests during CRAN check or devetools::test()

  example_paths1 <- local_example_dir(year_filter = 2024, site_filter = "AB2")
  # If setting up an example dir outside of a test use:
  #   setup_example_dir(year_filter = 2024, site_filter = "AB2")
  # It's the same but without a promise to delete later.

  site_dir1 <- dirname(example_paths1$deployment)

  ### Run test or developement code here


  example_paths2 <- local_example_dir(year_filter = 2024, site_filter = "E33")
  site_dir2 <- dirname(example_paths1$deployment)

})
