# nolint start: line_length_linter
#' Import Calibrated Deployment Data
#'
#' This function imports calibrated data for a single deployment from its
#'  `Calibrated` sub directory.
#' `import_calibrated_data()` calls distinct functions (import types)
#' depending on the  devices associated with the deployment in `placements.csv`
#  which is then used to look up an `import_type` in `import_type.csv`.
#' The called functions are internal to the package
#' and have the naming structure `import_calibrated_data_[x]`
#' where `[x]` is an integer.
#'
#'
#' ```{r child = "man/rmd/import_types.md"}
#' ```
#'
#' @param paths Path list as returned from [lookup_paths()].  Only the
#' `import_types` component is used here.
#' @param devices Device information in a list as returned from
#' [lookup_devices()].
#'
#' @return A list with two items the first `d` is a data frame with the
#' calibrated data containing the following columns.
#' \item{Date_Time}{The date and time of the observation as a string in the
#' format `yyyy-mm-dd hh:mm:ss`}
#' \item{Raw_DO}{Uncalibrated (measured) Dissolved Oxygen in mg/L }
#' \item{Temp_DOLog}{Temperature in Deg. Celsius as recorded by the DO logger}
#' \item{DO}{The calibrated (salinity adjusted) Dissolved Oxygen in mg/L}
#' \item{DO_Pct_Sat}{Dissolved oxygen percent saturation (calibrated)}
#' \item{Salinity_DOLog}{Salinity as recorded by the DO logger in ppt
#' (parts per thousand), this is equivalent to PSU (Practical Salinity Units) }
#' \item{High_Range}{High Range Conductivity in microsiemens per cm. Note newer
#' loggers may call this column "Electrical Conductivity" which is the same
#' thing, and even for those loggers it will be called High_Range throughout
#' the QC workflow.}
#' \item{Temp_CondLog}{Temperature in Deg. Celsius as recorded by the
#' conductivity logger}
#' \item{Spec_Cond}{The specific conductivity (new loggers) or specific
#' conductance (older loggers) in microsiemens per cm.}
#' \item{Salinity}{Salinity as recorded by the Conductivity logger in ppt
#' (parts per thousand), equivalent to PSU (Practical Salinity Units) which
#' is the units assigned by the newer loggers}
#' The second is `md`, a list of metadata information.
#' Details on the list contents are available
#' [here](https://docs.google.com/document/d/1GKw3eq9ALigEcX_AWl4vnlejSzsTiIVHzy6LoKCR1jw/edit?usp=sharing).
#'
#' @export
# nolint end
import_calibrated_data <- function(paths, devices) {

  models <- devices[grep("model", names(devices))] # drop serial number items
  # Determine import type
  it <- readr::read_csv(paths$import_types, show_col_types = FALSE)
  it$device <- tolower(it$device)
  import_type <- unique(it$import_type[it$device %in% tolower(models)])
  dev_text <- paste(unlist(devices), collapse = ", ") # for error messages

  if (length(import_type) > 1) {
    stop(dev_text,
         " devices should all have the same associated import type in ",
         paths$import_types)
  }

  if (length(import_type) == 0) {
    if (!"default" %in% it$device) {
      stop("Failed to resolve import type because neither",
           dev_text, " nor \"default\" are not listed in ",
           paths$import_types)
    }
    import_type <- it$import_type[it$device == "default"]
    message("Using default import type of ", import_type, " because ",
            dev_text, " are not in ", paths$import_types)
  }

  import_fun <-  paste0("import_calibrated_data_", import_type)
  if (!exists(import_fun)) {
    stop("The import function ", import_fun,
         "() is  not defined for import type ", import_type)
  }

  l <- do.call(what = import_fun, args = list(paths = paths))
  d <- l$d
  md <- l$md


  # see R/expected_column_names.R to adjust what is expected
  expected_cols <- get_expected_columns("calibrated", existing = names(d))
  miss <- setdiff(names(d), expected_cols)

  if (length(miss) > 0) {
    stop("Imported calibration data is missing expected column(s):\"",
         paste(miss, collapse = "\", \""))
  }

  # Check for expected top level metadata items and put in proper order
  md_order <- c("site",
                "deployment",
                "deployment_date",
                "calibration_start",
                "calibration_end",
                "pct_calibrated",
                "n_records",
                "pct_immediate_rejection",
                "pct_flagged_for_review",
                "logging_interval_min",
                "timezone",
                "auto_qc_date",
                "do_calibration",
                "do_deployment",
                "do_device",
                "cond_calibration",
                "cond_deployment",
                "cond_device",
                "import_type")

  md$import_type <- import_type
  stopifnot(all(md_order %in% names(md)))
  md <- md[md_order]

  # Tide Rider Import
  # If a tide rider was deployed at the "site" as indicated in
  # site, placements, and devices - see lookup_devices()
  if("tr_model" %in% names(models) && !is.na(models$tr_model)) {

     tr <- import_tide_rider(paths)

     # If already a depth column (From MX801) drop it here and
     # use tide rider depth instead
     if("Depth" %in% names(d))
       d$Depth <- NULL

     tr_pct <- sum(d$Date_Time %in% tr$Date_Time) / nrow(d) * 100
     if(tr_pct < 95)
       warning("Only ", round(tr_pct, 1), "% of the logger data is covered by the tide rider data")

     if(tr_pct == 0)
       stop("None of the tide rider date times match the logger date times. This is either because they don't cover the same range of times or because the times are slightly offset and so don't match.")

     # Add columns
     d <- dplyr::left_join(d, tr[, c("Date_Time", "Latitude", "Longitude", "Depth")], dplyr::join_by("Date_Time"))

     # Check for missing locations
     miss <- is.na(d$Longitude) | is.na(d$Latitude) | is.na(d$Depth)
     # Number of times that there is data where the preceeding value doesn't
     # have data
     n_starts <- sum( c(TRUE, miss) &
            !c(miss, TRUE), na.rm = TRUE)
     n_gaps <- n_starts - 1
     if(n_gaps != 0) {
       warning("There ",
               ifelse(n_gaps == 1, "is a gap", paste0("are ", n_gaps, " gaps")),
               " in the Tide Rider location information.")
     }
  }


  l <- list(d = d, md = md)

  return(l)
}
