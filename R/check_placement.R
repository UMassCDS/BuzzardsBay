#' Check SN, site, deployment date, and logger type against placements table
#'
#' This internal function verifies that the logger with the given SN was
#' placed at the expected, site, at the deployment date and that it is of the
#' expected type.
#'
#' @param sn The logger serial number
#' @param type The logger type: `"DO"`, or `"Cond"`
#' @param placements The placements table
#' @param deployment_date The deployment date (end of deployment window). A
#' deployment is a single dip in the water ending with a data download.
#' @param site The site where the logger was deployed
#'
#' @return An informative error is thrown if something is wrong.
#' Nothing is returned.
check_placement <- function(sn, type, placements, deployment_date, site) {
  placements$start_date <- format_csv_date(placements$start_date) |>
    lubridate::as_date()
  placements$end_date <- format_csv_date(placements$end_date)|>
    lubridate::as_date()
  names(placements) <- tolower(names(placements))
  type <- tolower(type)
  placements$type <- tolower(placements$type)
  deployment_date <- lubridate::as_date(deployment_date)


  timing_ok <- placements$start_date < deployment_date &
    !is.na(placements$start_date) &
    (is.na(placements$end_date) | placements$end_date > deployment_date)

  # Filter to just placements with appropriate timing
  placements <- placements[timing_ok, , drop = FALSE]

  # Filter to current SN
  placements <- placements[placements$sn %in% sn, , drop = FALSE]

  if (nrow(placements) == 0)
    stop("SN ", sn, " does not appear in the placment table on ",
         deployment_date, "\n")

  if (nrow(placements) > 1)
    stop("SN ", sn, " appears multiple times in the placment table on ",
         deployment_date, "\n")

  if (!placements$site %in% site)
    stop("SN ", sn, " does not appear to be associated with site ", site,
         " on ", deployment_date, "\n")

  if (!placements$type %in% type)
    stop("SN ", sn, " has type ", placements$type, " in the placement table",
         "but the calibration file names indicate that it is of type", type)

  return(invisible(NULL))
}
