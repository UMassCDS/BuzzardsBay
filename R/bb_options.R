# nolint start: cyclocomp_lintr
#' Set and retrieve BuzzardsBay package options
#'
#' With no arguments all the Buzzards Bay parameters will be returned as a list.
#'  Use a single character value to retrieve the value of a single option.
#'  Use one or more named arguments to set options.
#'
#' The options:
#' \describe{
#'
#' \item{`do_lv_duration`, `do_lv_range`}{For Low Variation
#' in Dissolved Oxygen (`Dlv`) flag. `do_lv_range` is the maximum difference
#' between the maximum and the minimum values in a streak longer than
#' `do_lv_duration` minutes before the the low variation in dissolved oxygen
#' (`Dlv`) flag is set}
#' \item{`do_max_jump`}{The maximum difference between consecutive DO
#' readings before the jump in dissolved oxygen (`Dj`) flag is is set.}
#' \item{`do_streak_duration`, `do_streak_min`}{If DO remains below
#' `do_streak_min`
#' for more than `do_streak_duration` than the Dissolved Oxygen low streak
#' (`Dls`) flag is set.}
#' \item{`logger_error_values`}{One or more values that indicate a logger
#'  error.  If setting multiple values in a YAML file use indented lines
#'  with a dash for each value:
#'  ```
#'  logger_error_values:
#'    - -888.88
#'    - 9999
#'  ```
#'  Temperature (from both loggers), High Range, and Raw DO are all checked
#'  for this value. Flags: `TDe`, `TCe`, `He`, and `Re`.}
#' \item{`max_hr`, `min_hr`}{Thresholds for the high high range (`Hh`) and low
#' high range (`Hl`) flags.}
#' \item{`max_raw_do`}{Threshold for the high raw DO (`Rh`) flag.}
#'  \item{`max_temp`, `min_temp`}{Thresholds for the high temperature
#'  (`TDh`, `TCh`) and low temperature (`TDl`, `TCl`)}
#'   \item{`plot_min_do`, `plot_max_do`, `plot_min_sal`, `plot_max_sal`,
#'   `plot_min_temp`, `plot_max_temp`}{ These constrain the Y range in
#'   the QC Report plots when plotting Dissolved Oxygen (`DO`),
#'   Salinity (`sal`), and temperature (`temp`)}
#'  \item{`sal_lv_duration`, `sal_lv_range`}{If the difference between the
#'  maximum and minimum salinity remains below `sal_lc_range` for more than
#'  `sal_lv_duration` minutes than the low variation in salinity (`Slv`) flag
#'  is set.}
#'   \item{`sal_max_jump`}{The maximum difference between successive salinity
#'   records before the salinity jump (`Sj`) flag is set for both involved
#'   records.}
#'
#'}
#'
#'
#' @param ... One of:
#'
#' 1. one or more named arguments where the name is a
#'   an option and the value its new setting e.g. `sal_max_jump = 0.75`;
#' 2. a single unnamed argument stating an option to retrieve e.g.
#'   `"sal_max_jump"`.
#' 3. No arguments, indicating that all options and their current settings
#'   should be returned in a list; or
#' 4. a single list argument with named items and their new values.
#'
#' @return If no arguments are used than all options will be returned as a list.
#'   If there is a single, unnamed argument with a character value indicating an
#'   option than the value of that option will be returned. Otherwise, the
#'   arguments should indicate new option settings and nothing will be returned.
#' @export
#'
#' @examples
#'  o <- bb_options()
#'  cat(yaml::as.yaml(o))
#'  bb_options(sal_max_jump = 0.5)
#'  bb_options("sal_max_jump")
#'  bb_options(o)  # Reset original options
#'  bb_options("sal_max_jump")
#'
bb_options <- function(...) {
  args <- list(...)
  if (length(args) == 0) {
    o <- as.list(bbp)
    o <- o[order(names(o))]
    return(o)
  }

  # Process single unnamed arguments by returning the relevant option(s)
  if (length(args) == 1 && is.null(names(args)) && !is.list(args[[1]])) {
    if (length(args[[1]]) > 1) {
      stop("You can only retrieve one option by name. Use bb_options() ",
           "(no arguments) to retrieve all options.")
    }
    if (args[[1]] %in% names(bbp)) {
      return(bbp[[args[[1]]]])
    } else {
      stop(paste(setdiff(args[[1]], names(bbp)), collapse = ", "),
           " is not a BirdFlowR configuration option.")
    }
  }

  # Special case where first argument is a list of arguments to set
  if (length(args) == 1 && is.list(args[[1]])) {
    args <- args[[1]]
  }

  if (any(is.null(names(args))))
    stop('Use "all" or a single argument name to retreive arguments.",
         "If setting multiple arguments all arguments must be named.')

  # Error if argument names aren't options
  if (!all(names(args) %in% names(bbp))) {
    missing <- setdiff(names(args), names(bbp))
    multiple <- length(missing > 1)
    stop(paste0(missing, collapse = ", "), ifelse(multiple, "are", "is"),
         "not a Buzzards Bay package option.")
  }

  # Assign named arguments to parameters
  for (i in seq_along(args)) {
    name <- names(args[i])
    value <- args[[i]]
    if (length(value) > 1) stop("All parameters take a single value")
    if (is.numeric(bbp[[name]]) && !is.numeric(value))
      stop("Please assign a numeric value to ", name)
    if (is.character(bbp[[name]]) && !is.character(value))
      stop("Please assign strings to ", name)
    if (is.na(value) || is.null(value))
      stop("You cannot assign NA or NULL to", name)
    bbp[[name]] <- value
  }


}
# nolint end
