
#' Look up expected column names and order
#'
#' `get_expected_columns()` looks up the column names and order expected at
#' different points in the data pipeline.  The columns themselves are
#' set in the `expected_columns` list object.
#'
#' At each step in the process there are both required and optional names
#' this function handles the fuzziness between those two - returning a final
#' set of column names, in canonical order.
#'
#' This function uses lists of column names defined separately in
#' `R/expected_column_names.R`. Edit that list to change the output.
#'
#' Note that there are no optional names for the four `final_*` result files.
#'
#' @param type What type (point along the data pipeline) are the names for,
#' currently one of
#' * `calibrated`  output from `import_calibrated_data()`
#' * `intermediate`  intermediate in QC process this includes the individual
#'    flag columns
#' * `qc_final`  output from `qc_deployment()`
#' * `final_all` complete set of columns in final files, used for archive
#'    result file
#' * `final_WPP` columns in the WPP result file
#' * `final_core` columns in the core result file
#' * `final_sensors` columns representing sensors WPP result file; may be set
#'    to "DR"
#' when rejected in QC
#' @param existing A vector of existing column names. This is used to determine
#' which of the optional column names are present
#' @returns A list of the expected names (including only the optional names
#' that are present) in canonical order.
#' @keywords internal

get_expected_columns <- function(type, existing = character(0)) {

  if (!type %in% names(expected_column_names))
    stop(type, " is not a valid type for get_expeected_columns()")


  # This makes sure that if the base version of these columns
  # is included than the other versions will also be when appropriate
  for(col in c("Depth", "Latitude", "Longitude")) {
    if(col %in% existing)
      existing <- unique(c(existing, paste0(col, c("_Flag", "_QC"))))
    cat("Adding", col, "\n")
  }

  # Expected cols includes a few that are optional
  expected <-  expected_column_names[[type]]
  optional <-  expected_column_names[[paste0("optional_", type)]]



  # Drop the missing optional cols from expected cols
  missing_optional <- optional[!optional %in% existing]
  expected_cols <-  expected[!expected %in% missing_optional]

  return(expected_cols)
}
