#' Clean up column names for basic CSV input
#'
#'`clean_csv_import_names()` is an internal function to resolve variable input
#' names into their canonical form.  It should work with input columns names
#' from the MX801 logger; from the U24 and U26 loggers; and using the canonical
#' names:  "Date_Time", "Raw_DO", "Temp_DOLog", "DO", "DO_Pct_Sat",
#' "High_Range", "Temp_CondLog", "Spec_Cond", "Salinity",
#' "Depth", "Latitude", and "Longitude".  The last three names are optional.
#'
#'  When combining names from the U24 and U26 loggers for use with this function
#'  the two temperature columns will have to be manually renamed to
#'  "Temp_CondLog", and "Temp_DOLog".
#'
#' @param d A data frame with possibly non-standard names.
#'
#' @returns A data frame with updated names.  Columns are not dropped or
#' re-ordered.
#' @keywords internal
clean_csv_import_names <- function(d) {

  #  Temporarily rename "Salinity_DOLog" so this optional column doesn't
  #   conflict with primary Salinity column
  if ("Salinity_DOLog" %in% names(d)) {
    d <- dplyr::rename(d, zzzzzzzzz_s = "Salinity_DOLog")
  }

  # Column crosswalk - regular expression pattern and accompanying name
  # nolint start: indentation_linter
  col_cw <- data.frame(
    pattern = c("Date.Time",
                "Temp.*DO",
                "Temp.*(CTD|Cond)",
                "((Measured|Raw).*DO)|(^DO.conc.[(]mg/L[)])",
                "(Salinity.Adjusted.*DO)|(^DO$)|(DO.*Adj)",
                "(Percent.Saturation)|(^DO_Pct_Sat^)|(DO.Percent.Sat)",
                "Salinity.[^Aa]", # exclude "Salinity-Adj.."
                "(^Electrical.Conductivity)|(^High.*Range)",
                "(^Specific.Cond)|(^Spec.Cond)",
                "(Water.Level)|(Depth)",
                "^Lat",
                "^Lon"),

    name = c("Date_Time",
             "Temp_DOLog",
             "Temp_CondLog",
             "Raw_DO",
             "DO",
             "DO_Pct_Sat",
             "Salinity",
             "High_Range",
             "Spec_Cond",
             "Depth",
             "Latitude",
             "Longitude"),
    required = c(rep(TRUE, 9), rep(FALSE, 3)))
  # nolint end
  cols <- names(d)
  for (i in seq_len(nrow(col_cw))) {
    cols[grep(col_cw$pattern[i], cols)] <- col_cw$name[i]
  }
  if (any(duplicated(cols)))
    stop("Duplicate input columns after name cleanup during simple import ",
         "from  CSV file:\n\t",
         paste(cols[duplicated(cols)], collapse = ",\n\t"))

  names(d) <- cols

  #  Restore "Salinity_DOLog" from temporary name
  if ("zzzzzzzzz_s" %in% names(d)) {
    d <- dplyr::rename(d, Salinity_DOLog = "zzzzzzzzz_s")
  }
  return(d)
}
