#' Create a BuzzardsBay parameter file
#'
#' The parameter file is used to set parameters that affect how
#' flags are calculated. See [bb_options()] for parameter descriptions.
#'
#' @param dir The path to a directory to write the file to generally either
#' the base directory for the data or a site directory.
#' @param overwrite if `TRUE` overwrite any existing file.
#'
#' @return Nothing is returned. A file is written to disk
#' @export
create_parameter_file <- function(dir, overwrite = FALSE) {
  stopifnot(dir.exists(dir))
  parameter_file <- file.path(dir, "bb_parameters.yml")
  if (file.exists(parameter_file) && !overwrite)
    stop("Parameter file already exists: ", parameter_file)
  text <- default_bbp |> as.list() |> yaml::as.yaml()

  header <-
    paste(
      "# This file sets parameters used by the BuzzardsBay R package.",
      "# For an explanation of the values load the package run these lines:",
      "#    library(BuzzardsBay)",
      "#    ?bb_options"
    )

  text <- c(header, text)

  writeLines(text, parameter_file)
}
