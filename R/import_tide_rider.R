# This is used to identify tide rider CSV files both here and
# in import_calibrated_data_0()
tide_rider_regex <- "[\\._]TR[\\._].*csv$"


#' Import Tide Rider Data
#'
#' This imports the location information for a Tide Rider from a CSV file.
#' See [import_calibrated_data()] for more information.
#'
#' @param paths paths list as returned from [lookup_paths()] the only
#' component used here is `$deployment_cal_dir`.  It should contain a
#' csv file with `"TR"` bounded by `"_"` or  `"."`  e.g. `"_TR_"` or `"_TR."`.
#'
#' @returns Tide Rider data with columns:
#' \item{Date_Time}{Date and time of each record as character in the
#' format year-month-day h:m:s (all numeric). The file can use that format
#' or day-month-year h:m:s where month is an abbreviated month name e.g.
#' "12-Aug-2025 13:40:00".}
#' \item{Latitude, Longitude}{Location in spherical coordinates. Assumed to
#' be WGS84 (EPSG:4326)}
#' \item{Depth}{Logger depth in meters}
#' \item{TR_Flags}{Tide Rider Flags.}
import_tide_rider <- function(paths) {

  l <- list.files(paths$deployment_cal_dir, full.names = TRUE)
  tr_csv <- l[grep(tide_rider_regex, basename(l), ignore.case = TRUE)]

  if(length(tr_csv) == 0 ) {
    stop("Expected a tide rider data file in ", paths$deployment_cal_dir,
         "but did not find one. It should have _TR. or _TR_ in the name end end in .csv")
  }

  if(length(tr_csv) > 1){
    stop("Expected a single tide rider data file in ", paths$deployment_cal_dir,
         " but found ", length(tr_csv), ". There should only be one CSV file with _TR. or _TR_ in the name.")
  }

  cat("\n\nReading Tide Rider Data\n",
      "\tFile: ", tr_csv, "\n", sep = "")

  tr <- readr::read_csv(tr_csv, na = c("NaN", "NA", "na", "nan", ""),
                        show_col_types = FALSE)

  # Clean and check column names
  n <- names(tr) |>
    gsub("\\(.*\\)", "", x = _) |>
    gsub("^[[:blank:]]*|[[:blank:]]*$", "", x = _)
  n[grep("logger depth", n, ignore.case = TRUE)] <- "Depth"
  n[grep("^Time$", ignore.case = T, n)] <- "Date_Time"
  n[grep("^Flags$", ignore.case = T, n)] <- "TR_Flags"

  expected_tr_names <- get_expected_columns("tide_rider")
  if (!all(expected_tr_names %in% n)) {
     miss <- setdiff(expected_tr_names, n )
     cat("Tider Rider csv ", tr_csv, " is missing expected columns: \"",
         paste(miss, collapse = "\", \""), "\"", sep = ""
         )
  }
  names(tr) <- n

  # Reformat dates
  # Formatting as characters in the standard format used by this package
  # (Y-m-d H:M:S  all numeric)
  # We are assuming here that the timezone matches the other input data
  # Only alternative is to require it to be specified in a separate yml file
  uses_day_month_year <- grepl("^[[:digit:]]{1,2}-[[:alpha:]]+-[[:digit:]]{2,4}[[:blank:]]", tr$Date_Time[1])
  if(uses_day_month_year)
    tr$Date_Time <- tr$Date_Time |>lubridate::dmy_hms()

  if(lubridate::is.timepoint(tr$Date_Time))
    tr$Date_Time <-format(tr$Date_Time, format = "%Y-%m-%d %H:%M:%S")

  if(!grepl("[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}[[:blank:]]+[[:digit:]]+:[[:digit:]]+:[[:digit:]]+", tr$Date_Time[1]))
    stop('Tide Rider input date times should match one of these formats: "2025-08-12 13:40:00" or "12-Aug-2025 13:40:00"')

  cat("\tRead ", nrow(tr), " rows of Tide Rider data", "\n\t",
      "From ", tr$Date_Time[1] , " to ", dplyr::last(tr$Date_Time), "\n\n",
      sep = "")

   return(tr)

}
