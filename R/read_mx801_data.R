
# nolint start: line_length_linter
#' Import data from MX801 logger
#'
#' @param file Path to a calibrated Excel (`.xlsx`) file from an MX801 logger
#'   Column descriptions in
#'   [google doc](https://docs.google.com/spreadsheets/d/1bYxi0nbgDaUsKEyLoj_ry-1Zc-A4MNDfS_J_zH7HiJI)
#'
#' @returns A data frame with standard data columns
#'
#' @keywords internal
# nolint end
read_mx801_data <- function(file) {

  stopifnot(file.exists(file))
  if (!grepl(".xlsx$", file, ignore.case = TRUE)) {
    stop("Expecting an .xlsx file for MX801 data import")
  }

  d <- readxl::read_excel(file, sheet = 1)

  # Column crosswalk - regular expression pattern and accompanying name
  col_cw <- data.frame(pattern = c("Date.Time",
                                   "Temperature.*-DO",
                                   "Temperature.*-CTD",
                                   "Measured.DO",
                                   "Salinity.Adjusted.DO",
                                   "Percent.Saturation",
                                   "Salinity.[^Aa]", # exclude "Salinity-Adj.."
                                   "Electrical.Conductivity",
                                   "Specific.Conductivity",
                                   "Water Level"),

                       name = c("Date_Time",
                                "Temp_DOLog",
                                "Temp_CondLog",
                                "Raw_DO",
                                "DO",
                                "DO_Pct_Sat",
                                "Salinity",
                                "High_Range",
                                "Spec_Cond",
                                "Depth"))

  cols <- names(d)
  for (i in seq_len(nrow(col_cw))) {
    cols[grep(col_cw$pattern[i], cols)] <- col_cw$name[i]
  }
  if (any(duplicated(cols)))
    stop("Multiple columns matched column lookup name during import from ",
         "MX801")

  names(d) <- cols

  # Previously we had two salinity columns this logger only
  # has one which we are using for both.
  d$Salinity_DOLog <- d$Salinity

  # Expected cols includes a few that are optional
  expected_cols <-  get_expected_columns("calibrated", names(d))

  # These are required columns that are missing
  missing_cols <- setdiff(expected_cols, names(d))

  if (length(missing_cols) > 0) {
    stop("Missing required columns from MX801 data inport: ",
         paste(missing_cols, collapse = ", "))
  }


  d <- d[, expected_cols]

  d$Date_Time <- as.character(d$Date_Time)

  return(d)

}
