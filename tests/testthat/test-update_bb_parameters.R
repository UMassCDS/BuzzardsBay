test_that("Package example parameter file is up to date", {
  example_base <- local_example_dir("parameters", year_filter = 2023)
  paths <- lookup_paths(deployment_dir = example_base$deployment)

  example_parameter_file <- system.file("extdata/bb_parameters.yml",
                                        package = "BuzzardsBay")

  p <- yaml::read_yaml(example_parameter_file)
  p <- p[order(names(p))]
  dp <-  default_bbp |> as.list()
  dp <- dp[order(names(dp))]
  expect_equal(p, dp)


  # If this test fails than parameters that have been set in in R/bbp.R
  # are not in the example parameters file and the line below will
  # update it - assuming the working directory is set to the package dir.
  if (FALSE) {
    create_parameter_file(dir = "inst/extdata/", overwrite = TRUE)
  }
})


test_that("Precedence and that vector logger_error_values work", {
  example_base <- local_example_dir("parameters", year_filter = 2023)
  paths <- lookup_paths(deployment_dir = example_base$deployment)

  # Global parameters set all values we are making two different than the
  # default
  p <- yaml::read_yaml(paths$global_parameters)
  p$max_hr <- 100000
  p$do_streak_min <- 1
  yaml::write_yaml(p, paths$global_parameters)

  # Site parameters just sets one value
  sp <- list(max_hr = 110000)
  yaml::write_yaml(sp, paths$site_parameters)

  update_bb_parameters(paths)

  expect_equal(bbp$max_hr, 110000)
  expect_equal(bbp$do_streak_min, 1)

  # Check that it can read multiple logger_error_values
  p <- yaml::read_yaml(paths$global_parameters)
  p$logger_error_values <- c(-888.88, -99999)
  yaml::write_yaml(p, paths$global_parameters)

  update_bb_parameters(paths)

  expect_equal(bbp$logger_error_values, c(-888.88, -99999))

  # This is the public facing way to get parameters
  expect_equal(bb_options("logger_error_values"), c(-888.88, -99999))

})
