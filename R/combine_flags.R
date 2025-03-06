#' Combine the flags from individual "_Flags" columns into
#' a single flags vector.
#'
#' This is a internal function called several times from `qc_deployment()`
#'
#' @param d A data frame.  Columns with "flag" in the name (ignoring case)
#' with the exception of a column called "Flags" (case specific) will
#' be concatinated into a return vector.
#'
#' @returns a vector of the combined flags
#' @keywords internal
combine_flags <- function(d){

  flag_cols <- grep("flag", names(d), ignore.case = TRUE, value = TRUE)
  other_flag_cols <- setdiff(flag_cols, "Flags")

  # Concatenate all the flags into d$Flags
  flags <- apply(
    d[, other_flag_cols], MARGIN = 1,
    FUN = function(x) paste(x[!is.na(x)], collapse = "", sep = ""))

  # Drop trailing ":" from flags
  flags <-  gsub(":$", "", flags)

  flags
}
