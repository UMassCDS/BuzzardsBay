
#' Look up expected column names and order
#'
#' `get_expected_columns()` looks up the column names and order expected at
#' different points in the data pipeline.  The columns them selves are
#' set in the `expected_columns`  list object.
#'
#' At each step in the process there are both required and optional names
#' this function handles the fuzzyness between those two - returning a final
#' set of column names, in canonical order.
#'
#' This function uses lists of column names defined separately in
#' `R/expected_column_names.R` edit that list to change the output.
#'
#' @param type What type (point along the data pipeline) are the names for,
#' currenttly one of
#' * `calibration`  output from `import_calibrated_data()`
#' * `intermediate`  intermediate in QC proces this includes the individual
#'    flag columns.
#' * `qc_final`  output from `qc_deployment()`
#' @param existing A vector of existing column names. This is used to determine
#' which of the optional column names are present
#' @returns A list of the expected names (including only the optional names
#' that are present) in canonical order.
#' @keywords internal
get_expected_columns <- function(type, existing = character(0)) {

  if(!type %in% names(expected_column_names))
    stop(type, " is not a valid type for get_expeected_columns()")

  # Expected cols includes a few that are optional
  expected <-  expected_column_names[[type]]
  optional <-  expected_column_names[[paste0("optional_", type)]]

  # Drop the missing optional cols from expected cols
  missing_optional <- optional[!optional %in% existing]
  expected_cols <-  expected[!expected %in% missing_optional]

  return(expected_cols)
}
