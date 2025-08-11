# nolint start: cyclocomp_linter
#' Update Buzzards Bay parameters
#'
#' Internal function to update the BuzzardsBay package parameters.  It sets
#' parameters based on the default parameters for the package,
#' a required global parameter file  (`paths$global_parameters`) and an
#' optional site specific parameter file (`paths$site_parameters`).
#'
#' The same parameter may be set in multiple locations in which case the
#' precedence in decreasing
#' order is site parameter file, global parameter file, and package default
#' value `default_bbp`.  The currently set parameters are stored in the `bbp`
#' environment within the package.
#'
#' Note, not all parameters need to be set in all locations. It is recommended
#' to set all the parameters in the global file and then only ones that need
#' to be changed in the site specific file.
#'
#' See [create_parameter_file()] to create a file with default values.
#'
#' @param paths Likely the output of [lookup_paths()] the only used items
#' are `$global_parameters` and `$site_parameters.`
#'
#' @return Nothing is returned, but package parameters are updated.
#' @export
#' @keywords internal
update_bb_parameters <- function(paths) {
  # bbp is an environment within the package that  is initialized
  # when the package is loaded.  See R/bbp.R and bb_options()

  if (is.na(paths$site_parameters)) {
    warning("Updating parameters without a site selected.",
            "Only global parameters will be used.")
  }

  if (is.na(paths$global_parameters)) {
    stop("No global parameters's set in paths. Cannot update parameters.")
  }

  # Reset values to default
  default_names <- names(default_bbp)
  for (n in default_names) {
    bbp[[n]] <- default_bbp[[n]]
  }

  vector_parameters <- "logger_error_values"

  # Update based on parameter files first use
  # the global parameters than use the site parameters
  files <- paths$global_parameters
  # Site takes precedence over global so is processed second
  if(!is.na(paths$site_parameters)) {
    files <- c(files, paths$site_parameters)
  }

  for (i in seq_along(files)) {
    f <- files[i]
    if (i == 1 && !file.exists(f)) {
      # Global parameter file isn't optional
      stop("Missing Buzzards Bay parameter file:", f)
    }

    # All other files (currently just site parameters) are optional
    if (!file.exists(f))
      next

    p <- yaml::read_yaml(f)
    p_names <- names(p)

    valid_names <- base::intersect(p_names, default_names)

    for (n in valid_names) {

      # Handle special case where yaml file returns integer but default type
      # is double (which fails valid type check)
      if (is.integer(p[[n]]) && is.double(default_bbp[[n]])) {
        p[[n]] <- as.double(p[[n]])
      }

      # Check that the type of value is as expected
      default_type <- typeof(default_bbp[[n]])
      this_type <- typeof(p[[n]])


      if (!this_type == default_type) {
        stop("Expected ", n, " to be a ", default_type, " but it is a ",
             this_type, " - in ", f)
      }

      # Check that it is either scalar or in the vector_parameters
      # currently only "logger_error_values" is allowed to be longer than
      # a single value.
      val <- p[[n]]
      if(length(val) != 1 && !n %in% vector_parameters) {
        stop("Expected ", n, " to be a single value found ", length(val),
             " - in ", f)
      }

      # Copy parameter over
      bbp[[n]] <- val
    }
  }


}
# nolint end
