# nolint start: line_length_linter
#' Import Calibrated Data
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
#' # Import types
#'
#' ## Import Type 0 - CSV
#'  This simple CSV import is a fallback in case updates to HOBOware or
#'  the loggers themselves break the targeted imports.
#'  It expects a CSV file and a YAML (`.yml`) file.
#'
#'  To use this import:
#'   1. Make sure in `import_types.csv` there's a default line:
#'   `default,0` This means that if an import type isn't identified for a model
#'   listed in a placement that the CSV import will be used.
#'  2. In `placments.csv` if you want to use the CSV import use a model name
#'  that is NOT in `import_types.csv` so the default CSV import is used.
#'   I recommend using the model name with `-CSV` appended; e.g.
#'    instead of `MX801` use `MX801-CSV`.
#' 3. In the deployment's `Calibrated` directory create an appropriate CSV and
#' YAML file as described below.
#'
#' ### CSV file
#' In the CSV file the columns are resolved by name not order and the import
#' will attempt to resolve several different column naming conventions. Any
#' of the following should work:
#'
#'   * The canonical column names used by this package:  "Date_Time", "Raw_DO",
#' "Temp_DOLog", "DO", "DO_Pct_Sat", "High_Range", "Temp_CondLog",
#' "Spec_Cond", "Salinity", "Depth", "Latitude", and "Longitude". The last
#' three are optional, the rest are required.
#' * Columns names from the MX801 logger. For example by saving the first sheet
#' as a CSV.
#' * Column names from the U24 and U26 loggers. However, when combining data
#' from these two loggers into a single CSV the two temperature columns will
#' have to be manually renamed to "Temp_CondLog", and "Temp_DOLog"
#' as they are otherwise indistinguishable.
#'
#' If using other column names please verify carefully
#  that the various DO, Conductivity, and Salinity columns
#  are properly identified.
#  For example make sure the resulting "DO" column has the calibrated values
#  and the "Raw_DO" column has the un-calibrated values.
#'
#' ### YAML file
#'
#' In the YAML file the following items are required:
#'
#'   * **calibration_start:** The date and time of the start of the deployment.
#' For field calibrated sensors (U24, U26) this is also the calibration time.
#' For factory calibrated sensors (MX801) this is NOT the calibration time.
#' * **calibration_end:** As in the above, the end of the deployment and/or
#' calibrated window.
#' * **timezone:** The timezone as reported by the logger and/or calibration
#' software.
#' The output from HOBOware uses a GMT offset like "GMT-04:00",
#' which is not a broadly supported timezone but is accepted here.
#' The MX801 uses a timezone code "EST" which is also accepted here.
#' * **do_device:** Information on the DO sensor or logger with items:
#'   * **product:** The dissolved oxygen sensor e.g.
#'  "HOBO U26-001 Dissolved Oxygen", "U26-01", or "MX801".
#' * **serial_number:** The device serial number.
#' * **cond_device:** List with information on the conductivity sensor with
#'   items:
#'   * **product:** The conductivity sensor e.g. "HOBO U24-002 Conductivity"
#'   * **serial_number:** Conductivity sensor serial number
#' Additional items that appear in the
#' [metadata documentation](https://docs.google.com/document/d/1GKw3eq9ALigEcX_AWl4vnlejSzsTiIVHzy6LoKCR1jw/edit?tab=t.0)
#' are permitted and will be retained. Items that do not appear in that document
#' will be ignored.
#'
#' ## Import Type 1 - U24, U26
#  This is the original input type that used calibrated data exported from
#' HOBOware derived from U24 and U26 loggers.
#' Import type 1 expects to find two CSV files and two `details.txt`
#' files in the calibration directory. The Dissolved Oxygen files should have
#' `"Do_"` somewhere in the names while the Conductivity files should have
#' either `"Cond_"` or `"Sal_` in the names.
#'
#' ## Import Type 2 - MX801
#' This is the import type for the MX801 logger, it expects a single `.xlxs`
#' file  with combined data from both loggers and on the first sheet
#' and the details (metadata) on the third sheet.
#' Note there should still be two lines for each placement  in `placements.csv`
#' one each for `"DO"` and `"Cond"` both of which should indicate "MX801" as the
#' model and have the same Serial Number.
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

  # Check for expected top level metdata items and put in proper order
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
                "cond_device")

  stopifnot(all(md_order %in% names(md)))

  md <- md[md_order]

  l <- list(d = d, md = md)

  return(l)
}
