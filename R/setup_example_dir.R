#' Setup an example directory
#'
#' Setup an example directory for testing and demonstrating the **BuzzardsBay**
#' package functions. It will be created within `parent_dir` called `"BB_Data"`
#' and will contain example calibrated data files for a single deployment as
#' well as some of project level metadata.  The files are bundled with the
#' package and can be found in the source within `inst/extdata/`.
#'
#' @param parent_dir The directory in which to create the example files tree.
#' If left `NULL` it will be set to [tempdir()]. Either way
#' an error will be thrown if this a `"BB_Data"` folder already exists
#' in `parent_dir`.
#'
#' @return A named list with paths to:
#' \item{base_dir}{The path to the newly created example
#' base directory (`"BB_Data"`).}
#' \item{deployment_dir}{The path to the example deployment folder within
#' `base_dir`.}
#' @export
#'
#' @examples
#' \dontrun{
#' setup_example()
#' }
setup_example_dir <- function(parent_dir = NULL) {
  if (is.null(parent_dir)) {
    parent_dir <- tempdir(check = TRUE)
  }

  if (!file.exists(parent_dir))
    dir.create(parent_dir)

  example_base <- file.path(parent_dir, "BB_Data")
  if (file.exists(example_base))
    stop("Example base dir: ", example_base, " already exists.")

  source_dir <- system.file("extdata/Calibrated", package = "BuzzardsBay")
  destination <- file.path(example_base, "2023", "RB1", "2023-06-09")
  dir.create(destination, recursive = TRUE)

  file.copy(source_dir, destination, recursive = TRUE)

  # Copy metadata files - sites.csv, placements.csv
  dest_md_dir <- file.path(example_base, "2023", "Metadata")
  dir.create(dest_md_dir, recursive = TRUE)
  sites <-  system.file("extdata/sites.csv", package = "BuzzardsBay")
  file.copy(sites, dest_md_dir)
  placements <- system.file("extdata/placements.csv", package = "BuzzardsBay")
  file.copy(placements, dest_md_dir)




  return(list(base = example_base,
              deployment = destination))

}
