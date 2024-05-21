#' Suppress some specific warnings
#'
#' `suppress_specific_warnings()` will suppress warnings that match regular
#' expression patterns that are either coded into the function or supplied via
#' the `patterns` argument, without suppressing warnings that don't match the
#' patterns.
#'
#' It's initial (possibly only) use is to catch a warning thrown by ggplot due
#' to NA value created by using lead() when plotting time of day.
#'
#' `suppress_specific_warnings()` is used in the rmarkdown report so needs
#' to be a public function but it is not intended for external use.
#'
#' @keywords internal
#' @param x An expression.
#' @param patterns One or patterns to check warning messages against.
#'
#' @return Possibly output from `x`
#' @export
#' @examples
#' suppress_specific_warnings(warning("this is a warning"), "this is")
#' suppress_specific_warnings(warning("this is a warning"))
#'
suppress_specific_warnings <- function(x, patterns = NULL) {


  suppress_patterns <- c(
    "Removed .* row.* containing missing values or values"
  )

  if (!is.null(patterns))
    suppress_patterns <- c(suppress_patterns, patterns)

  any_match <- function(cnd, patterns) {
    any(sapply(patterns, function(x) grepl(x, cnd)))
  }

  check_warning <- function(w) {
    if (any_match(conditionMessage(w), suppress_patterns))
      invokeRestart("muffleWarning")
  }

  withCallingHandlers(x, warning = check_warning)

}
