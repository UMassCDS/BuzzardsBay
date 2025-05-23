
# nolint start:cyclocomp_linter
#' Lookup paths for data and parameter files
#'
#' This includes all the paths that relate to a deployment, site, year, or
#' the entire data base.
#'
#' The easiest way to call it is to specify the deployment directory
#' (`deployment_dir`) in which case all other arguments are inferred from the
#' path. Otherwise specify at a minimum `base_dir`, `year`, and `site`; and,
#' optionally `deployment_date` and all paths that can be specified will be.
#'
#' @param base_dir The base directory for all the data.
#' @param year The four digit year for which paths are to be looked up
#' @param site The site name for which the paths are to be looked up
#' @param deployment_date The deployment date in the form `yyyy-mm-dd`, where
#' `yyyy` is a four digit year, `mm` is a two digit month and `dd` is a two
#' digit day.  Single digit components should be padded e.g. `01` for January.
#' @param deployment_dir (optional) The full path to a deployment's directory.
#' If `deployment_dir` is used, all other arguments are ignored and instead
#' their values are inferred from this path.
#'
#' @return A list of paths and a few related non-path variables.  The items
#' returned are all always the same and in the same order but with some inputs
#' the deployment specific items will not be defined so will have `NA` values.
#' All list items contain a single string.
#' \item{base_dir}{The path to the base directory for the data.}
#' \item{year_dir}{The path to a specific year's directory}
#' \item{site_dir}{The path to a specific site's directory}
#' \item{md_dir}{The path to a metadata  / parameter directory. Containing
#' additional information about sites and placements for the given year}
#' \item{deployment_dir}{The path to the deployment directory where all the
#' data (raw, calibrated, and QC'd) for a deployment is stored.  A deployment
#'  is the period a device is continuously in the water preceding data
#'  download from the device, typically about a week for this project.}
#' \item{deployment_cal_dir}{The deployment calibration directory path}
#' \item{deployment_auto_qc}{The deployment Auto QC file path this file is
#' created by [qc_deployment()] as a permanent record of the output of the
#' automated QC process. It should not be modified.}
#' \item{deployment_prelim_qc}{This is the preliminary QC file. It is created
#'  by [qc_deployment()] and is intended to be edited by people during the AC
#' process who will, at completion of that process delete the `"preliminary_"`
#' from the beginning of the name.}
#' \item{deployment_final_qc}{This is the final QC file created from
#'   `deployment_prelim_qc` by people performing the QC.}
#' \item{deployment_metadata}{This file contains metadata from the HOBOware
#' Details files and generated by [qc_deployment()].}
#' \item{deployment_report}{An html report with plots to inform the QC process.}
#' \item{preceding_auto_qc}{The path to the auto QC file for the preceding
#' deployment if it exists, NA otherwise.}
#' \item{sites}{CSV file with sites and associated information. The sites file
#' is  maintained by the users.}
#' \item{placements}{CSV tracking placements.  The placement is the period a
#'  specific device is at a site. The placements file is maintained by
#'  the users.}
#' \item{import_types}{File connecting device models (in placements file) to
#'  the import type, an integer, used to import the calibrated data derived
#'  from those device models each import type must be supported with a
#'  function named `import_calibrated_data_{type}`. where type the integer.
#'  See for example `import_calibrated_data_1` which handles the CSV output
#'  from HOBOware.
#'  The public function [import_calibrated_data()] handles dispatch
#'  to the numbered functions and does some additional formatting and checking
#'  of the output.}
#' \item{global_parameters}{This YAML (`.yml`) file sets global
#' parameters for the BuzzardsBay package, most of which affect how flags
#' are calculated.  See `update_bb_parameters`}
#' \item{site_parameters}{This YAML takes precedence over
#' `global_parameters` and allows adjusting them to a particular site}
#' \item{year}{NOT a path This is the four digit year in character format}
#' \item{deployment_date}{NOT a path. This is the deployment date as a
#'  character in `yyyy-mm-dd` format.  Numbers are padded e.g. `01` for
#' January.}
#' \item{site}{NOT a path. This is the site name. It is case sensitive and
#' should appear exactly as it does in the sites table (`sites`).}
#' @export
lookup_paths <- function(base_dir = NULL, year = NULL, site = NULL,
                         deployment_date = NULL, deployment_dir = NULL) {

  # Full empty list in standard order
  p <- list(base_dir = NA_character_,
            year_dir = NA_character_,
            site_dir = NA_character_,
            md_dir = NA_character_,
            deployment_dir = NA_character_,
            deployment_cal_dir = NA_character_,
            deployment_auto_qc = NA_character_,
            deployment_prelim_qc = NA_character_,
            deployment_final_qc = NA_character_,
            deployment_metadata = NA_character_,
            deployment_report = NA_character_,
            preceding_auto_qc = NA_character_,
            sites = NA_character_,
            placements = NA_character_,
            import_types = NA_character_,
            global_parameters = NA_character_,
            site_parameters = NA_character_,

            # These three are not paths but are useful
            year = NA_integer_,
            deployment_date = NA_character_,
            site = NA_character_)



  expected_names <- names(p)

  # If deployment directory is defined then use it to define all other
  # arguments (base_dir, year, site, deployment_date)
  if (!is.null(deployment_dir)) {
    # Standardize deployment dir path
    deployment_dir <- gsub("[/\\\\]+", .Platform$file.sep, deployment_dir)
    deployment_dir <- gsub("[/\\\\]$", "", deployment_dir) # drop trailing /

    base_dir <- cut_path_items(deployment_dir, 3)
    dirs <- strsplit(deployment_dir, "[/\\\\]+")[[1]]
    deployment_date <- dirs[length(dirs)]
    site <- dirs[length(dirs) - 1]
    year <- dirs[length(dirs) - 2]
    rm(dirs) # just used for three lines above
  }

  if (is.null(base_dir)) {
    stop("Need to define base_dir or or deployment_dir")
  }

  # base files (don't need year, site, or deployment_date)
  p$base_dir <- base_dir
  p$global_parameters <-  file.path(p$base_dir, "bb_parameters.yml")

  # Year specific stuff
  if (!is.null(year)) {
    if (!all(grepl("^[[:digit:]]{4}", year))) {
      stop("year should be a four digit number")
    }
    p$year <- year
    p$year_dir <- file.path(base_dir, year)
    p$md_dir <- file.path(p$year_dir, "Metadata")
    p$sites <- file.path(p$md_dir, "sites.csv")
    p$placements <- file.path(p$md_dir, "placements.csv")
    p$import_types <- file.path(p$base_dir, "import_types.csv")
  }

  # Site specific stuff (also requires year)
  if (!is.null(year) && !is.null(site)) {
    p$site <- site
    p$site_dir <- file.path(base_dir, year, site)
    p$site_parameters <- file.path(p$site_dir, "bb_parameters.yml")
  }


  # Deployment specific
  if (!is.null(year) && !is.null(site) && !is.null(deployment_date)) {

    if (!all(grepl("^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}$",
                   deployment_date))) {
      stop("The deployment date (", deployment_date, ") does not meet the ",
           "expected yyyy-mm-dd format.",
           " It should represent year-month-day with four digits for year and ",
           "2 digits for both month and day.")
    }


    deployment_dir <- file.path(base_dir, year, site, deployment_date)
    p$deployment_date <- deployment_date
    p$deployment_dir <- deployment_dir
    p$deployment_cal_dir <-  file.path(deployment_dir, "Calibrated")
    p$deployment_auto_qc <-
      file.path(deployment_dir,
                paste0("Auto_QC_", site, "_", deployment_date, ".csv"))
    p$deployment_prelim_qc <-
      file.path(deployment_dir,
                paste0("Preliminary_QC_", site, "_",
                       deployment_date, ".csv"))
    p$deployment_final_qc <-
      file.path(deployment_dir,
                paste0("QC_", site, "_", deployment_date, ".csv"))
    p$deployment_metadata <-
      file.path(deployment_dir,
                paste0("Metadata_", site, "_", deployment_date, ".yml"))
    p$deployment_report <-
      file.path(deployment_dir,
                paste0("QC_", site, "_", deployment_date, "_report.html"))

    p$deployment_auto_qc <- file.path(deployment_dir,
                                      paste0("Auto_QC_", site, "_",
                                             deployment_date, ".csv"))
    p$deployment_prelim_qc <- file.path(deployment_dir,
                                        paste0("Preliminary_QC_", site,
                                               "_", deployment_date,
                                               ".csv"))
    p$deployment_final_qc <- file.path(deployment_dir,
                                       paste0("QC_", site, "_",
                                              deployment_date, ".csv"))
    p$deployment_metadata <- file.path(deployment_dir,
                                       paste0("Metadata_", site, "_",
                                              deployment_date, ".yml"))
    p$deployment_report <- file.path(deployment_dir,
                                     paste0("QC_", site, "_",
                                            deployment_date,
                                            "_report.html"))

    #--------------------------------------------------------------------------#
    # Identify preceding deployment auto qc file
    # This is used when making reports
    #--------------------------------------------------------------------------#

    deps <- list.files(p$site_dir,
                       pattern =
                         "^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}$")
    other_deps <- setdiff(deps, deployment_date) |>
      lubridate::as_date()
    preceding_deps <-
      other_deps[other_deps < lubridate::as_date(deployment_date)]

    if (length(preceding_deps > 0)) {
      preceding_dep <-  max(preceding_deps)
      preceding_dep_dir <- file.path(p$site_dir, preceding_dep)
      # data_names are possible files for the preceding deployment
      data_names <- paste0(c("QC", "Auto_QC"),
                           "_", site, "_",
                           preceding_dep, ".csv")
      data_paths <- file.path(preceding_dep_dir, data_names)

      p$preceding_auto_qc <- data_paths[file.exists(data_paths)][1]

      rm(preceding_dep, preceding_dep_dir, data_names, data_paths)
    }

    rm(deps, other_deps, preceding_deps)

  } # END deployment specific stuff


  if (!isTRUE(all.equal(names(p), expected_names))) {
    stop("Path lookup failed to produce expected list.",
         "This is likely a problem with the package code.")
  }

  return(p)
}
#nolint end
