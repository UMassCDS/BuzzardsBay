
#' Import Calibrated Data
#'
#' This function imports calibrated data from `paths$deployment_cal_dir`
#' it calls distinct functions depending on the devices associated with the
#' deployment based on the `import_type` associated with the devices in
#' the  `import_type.csv` file in the base directory for the Buzzards Bay
#' data.
#'
#' Import types:
#' 1. The original input type that used calibrated data exported from
#' Hobo ware.  This expects to find two CSV files and two `detailes.txt`
#' files in the calibration directory. The Dissolved Oxygen files should have
#' `"Do_"` somewhere in the names while the Conductivity files should have
#' either `"Cond_"` or `"Sal_` in the names.
#'
#' 2. This is the import type associated with the `MX801` logger. Note
#' there should still be two lines in `placements.csv` one each for
#' `"Do"` and `"Cond"` both of which should indicate "MX801".  This import
#' expects a single  excel file with combined data from both loggers and on
#' one sheet and the details information on another.  NOT IMPLEMENTED YET.
#'
#' @param paths Path list as returned from `[lookup_paths()]`.  Only the
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
#' @export
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

  # see R/expected_column_names.R
  miss <- setdiff(names(d), expected_column_names$calibrated)

  if (length(miss) > 0) {
    stop("Imported calibration data is missing expected column(s):\"",
         paste(miss, collapse = "\", \""))
  }

  return(l)
}
