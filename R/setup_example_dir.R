# nolint start: cyclocomp_linter
#' Set up an example directory
#'
#' Set up an example directory for testing and demonstrating the **BuzzardsBay**
#' package functions. It will be created within `parent_dir` called `"BB_Data"`
#' and will contain example calibrated data files for a single deployment as
#' well as some of project level metadata.  The files are bundled with the
#' package and can be found in the source within `inst/extdata/`.
#'
#' @param parent_dir The directory in which to create the example files tree.
#' If left `NULL` it will be set to [tempdir()]. Either way
#' an error will be thrown if this a `"BB_Data"` folder already exists
#' in `parent_dir` - unless `delete_old` is `TRUE`/
#'
#' @param delete_old If `TRUE` then preexisting example data is deleted.
#' @param year_filter Optional, if specified only example data from
#' deployments from the specified year will be copied over.
#' @param site_filter Optional if specified only example data from the
#'  specified site will be copied over.
#' @param deployment_filter Optional, if specified only example data from
#' the given deployment will be copied over. Should be a deployment date
#' e.g. `"2023-06-09`.

#' @return A named list with paths to:
#' \item{base_dir}{The path to the newly created example
#' base directory (`"BB_Data"`).}
#' \item{deployment_dir}{The path to the first deployment folder within
#' `base_dir`.}
#' \item{deployment_dirs}{A vector of paths to all the example deployment
#' directories created }
#' @export
#' @section Example data sets:
#'
#' ## 2023
#'
#' * **RB1 2023-06-09** The original example data used to developing the
#' package.
#'
#' * **WH1X 2023-06-09, 2023-06-16, 2023-06-23** This site includes QC'd
#' files; it corresponds to the included 2023 Baywatchers data from
#' `extract_baywatchers()`, which is required for two of the figures
#' in the seasonal report.
#'
#' ## 2024
#'
#' These were generally added to resolve errors that came up.
#'
#' * **OB9** The first 2024 data set. Added to document changes from
#' 2023 but otherwise is fairly standard.
#'
#' * **OB1 2024-05-21, 2024-05-31**  Added to resolve an issue where a sensor
#' was swapped and `placements.csv` updated to indicate the swap, BUT the QC
#' module was still throwing errors.
#'
#' * **SB2X 2024-05-15, 2024-06-10** Conductivity was calibrated with a single
#' point calibration for these two deployments.
#'
#' * **BD1 2024-06-21** One of the calibrated conductivity columns is
#' weird in this data set has "High Range High Range"  instead of "High Range".
#'
#' @examples
#' \dontrun{
#' setup_example()
#' }
setup_example_dir <- function(parent_dir = NULL, delete_old = FALSE,
                              year_filter = NULL,
                              site_filter = NULL,
                              deployment_filter = NULL) {
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

  deployments <- character(0)


  extdata <- system.file("extdata", package = "BuzzardsBay")
  years <- list.files(extdata, pattern = "^[[:digit:]]{4}$")
  if (!is.null(year_filter)) {
    years <- intersect(years, as.character(year_filter))
    if (length(years) == 0)
      stop("No year_filter years are in the example data")
  }


  deployment_dirs <- character(0)

  # Copy over deployment data from year folders
  for (year in years) {
    year_dir <- file.path(extdata, year)


    sites <- setdiff(list.dirs(year_dir, full.names = FALSE,
                               recursive = FALSE), "")
    for (site in sites){
      if (!is.null(site_filter) && !site %in% site_filter) {
        next
      }
      site_dir <- file.path(year_dir, site)

      files <- list.files(site_dir, recursive = TRUE, full.names = FALSE)


      if (!is.null(deployment_filter)) {
        files <- grep(deployment_filter, files, value = TRUE)
        if (length(files) == 0)
          stop("All deployments were filtered out.")
      }


      source_files <- file.path(site_dir, files)
      dest_site_dir <- file.path(example_base, year, site)
      dir.create(dest_site_dir, showWarnings = FALSE)
      dest_files <- file.path(dest_site_dir, files)
      dest_dirs <- dirname(dest_files) |> unique()
      sapply(dest_dirs, dir.create, recursive = TRUE, showWarnings = FALSE)
      file.copy(source_files, dest_files)

      # Keep track of new deployment dirs

      # Clip out the just the deployment name
      deployments <- gsub("(^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}).*$",
                          "\\1", files, perl = TRUE) |> unique()

      # Drop anything that wasn't a deployment eg readme file
      deployments <- grep("^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}$",
                          deployments, value = TRUE)
      deployment_dirs <- c(deployment_dirs,
                           file.path(dest_site_dir, deployments))
    }

    if (file.exists(f <- file.path(year_dir, 'baywatchers.csv')))       # get Baywatchers data if it exists for this year
      file.copy(f, file.path(example_base, year))
    if (file.exists(f <- file.path(year_dir, 'bay_hash.txt')))
      file.copy(f, file.path(example_base, year))
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

  # Copy import_types.csv and bb_parameters.yml into base director
  file.copy(system.file("extdata/import_types.csv", package = "BuzzardsBay"),
            example_base)
  file.copy(system.file("extdata/bb_parameters.yml", package = "BuzzardsBay"),
            example_base)


  return(list(base = example_base,
              deployment = deployment_dirs[1],
              deployments = deployment_dirs))

}
#nolint end: cyclocomp_linter
