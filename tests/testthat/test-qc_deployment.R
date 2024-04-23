test_that("qc_deployment() works", {

  paths <- local_example_dir()

  expect_no_error(d <- qc_deployment(paths$deployment))

})
