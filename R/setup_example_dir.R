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
#' @param delete_old If `TRUE` then preexisting example data is deleted.
#'
#' @return A named list with paths to:
#' \item{base_dir}{The path to the newly created example
#' base directory (`"BB_Data"`).}
#' \item{deployment_dir}{The path to the default deployment folder within
#' `base_dir`.}
#' \item{deployment_dirs}{A vector of paths to example deployment directories.}
#' @export
#'
#' @examples
#' \dontrun{
#' setup_example()
#' }
setup_example_dir <- function(parent_dir = NULL, delete_old = FALSE) {
  if (is.null(parent_dir)) {
    parent_dir <- tempdir(check = TRUE)
  }
  if (!file.exists(parent_dir))
    dir.create(parent_dir)

  example_base <- file.path(parent_dir, "BB_Data")

  if (file.exists(example_base)  && delete_old) {
    unlink(example_base, recursive = TRUE)
    Sys.sleep(.1)
  }

  if (file.exists(example_base))
    stop("Example base dir: ", example_base, " already exists.")

  destinations <- character(0)


  extdata <- system.file("extdata", package = "BuzzardsBay")
  years <- list.files(extdata, pattern = "^[[:digit:]]{4}$")

  deployment_dirs <- character(0)

  # Copy over deployment data from year folders
  for(year in years) {
    year_dir <- file.path(extdata, year)
    files <- list.files(year_dir, recursive = TRUE)
    deployments <-
      gsub("(^[^/]+/[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}).*$",
           "\\1", files, perl = TRUE) |> unique()
    source_files <- file.path(year_dir, files)
    dest_year_dir <- file.path(example_base, year)
    dir.create(dest_year_dir, showWarnings = FALSE)
    dest_files <- file.path(dest_year_dir, files)
    dest_dirs <- dirname(dest_files) |> unique()
    sapply(dest_dirs, dir.create, recursive = TRUE, showWarnings = FALSE)
    file.copy(source_files, dest_files)
    deployment_dirs <- c(deployment_dirs,
                         file.path(dest_year_dir, deployments))
  }

  # Copy metadata files - sites.csv, placements.csv to metadata folders for
  # each year
  for (year in years) {
    dest_md_dir <- file.path(example_base, year, "Metadata")
    dir.create(dest_md_dir, recursive = TRUE)
    sites <-  system.file("extdata/sites.csv", package = "BuzzardsBay")
    file.copy(sites, dest_md_dir)
    placements <- system.file("extdata/placements.csv", package = "BuzzardsBay")
    file.copy(placements, dest_md_dir)
  }

  return(list(base = example_base,
              deployment = deployment_dirs[1],
              deployments = deployment_dirs))

}
