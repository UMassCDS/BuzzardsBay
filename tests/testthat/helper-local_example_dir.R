#' Setup an example directory for tests that will delete itself
#'
#' This calls [setup_example_dir()] after creating a temp dir with the
#' approach used by [withr::local_temp_dir()] to set up a defered promise to
#' delete the example directory when the parent scope (the test) is exited.
#' @param subdir The name of a subdirectory to build the example within.
#' @param env Leave this argument alone.
#' @inherit setup_example_dir returns
local_example_dir <- function(subdir = "bb_test", env = parent.frame()) {
  test_dir <- file.path(tempdir(), subdir)
  if (file.exists(test_dir))
    unlink(test_dir, recursive = TRUE)
  dir.create(test_dir)
  paths <- setup_example_dir(test_dir)
  withr::defer(unlink(test_dir, recursive = TRUE), envir = env)
  return(paths)
}
