#' Lookup the DO and conductivity logger device models
#'
#' Given a deployment date and site lookup the sensors deployed there.
#' The assumption is that there is both a `"Do"` and
#' `"Cond"` device type associated with each placement and this function
#' will throw and error if that is violated for the specified deployment.
#'
#' @param site The site where the logger was deployed
#' @param deployment_date The deployment date (end of deployment window). A
#' deployment is a single dip in the water ending with a data download.
#' @param placements The placements table
#' @return A list with items:
#'  \item{do_model,do_sn}{ Dissolved oxygen sensor model and serial number}
#'  \item{cond_model,cond_sn}{ Conductivity sensor model and serial number}
#' @importFrom rlang .data
lookup_devices <- function(site, deployment_date, placements) {

  deployment_date <- lubridate::as_date(deployment_date)

  # Filter to just placements with appropriate timing
  # Note deployment_date is the last day of the deployment so
  # we expect it to be later than the start date
  timing_ok <- placements$start_date <= deployment_date &
    !is.na(placements$start_date) &
    (is.na(placements$end_date) | placements$end_date >= deployment_date)
  placements <- placements[timing_ok, , drop = FALSE]

  # Filter to current SITE
  placements <- placements[placements$site %in% site, , drop = FALSE]

  if (any(duplicated(placements$type))) {
    # One reason for duplicates is if the deployment date is the
    # same as the end date of one placement and the start date of another.
    # in which case we want to use the first placement because the
    # deployment date represents the end of a deployment.
    # This takes the earliest placement for each combination of
    # site and type
    placements <- placements |>
      dplyr::arrange(.data$start_date, .data$end_date) |>
      dplyr::group_by(.data$site, .data$type) |>
      dplyr::filter(dplyr::row_number() == 1)

  }


  if (nrow(placements) == 0)
    stop("There is no placement associated with ", site,
         " for ", deployment_date)


  if (any(duplicated(placements$type))) {
    stop("There are duplicated types associated with ", site,
         " on ", deployment_date)
  }

  types <- placements$type
  if (!setequal(types, c("do", "cond"))) {
    stop("There should be both a DO and Cond type in placements for ",
         site, " on ", deployment_date)
  }

  return(list(do_model = placements$model[placements$type == "do"],
              do_sn = placements$sn[placements$type == "do"],
              cond_model = placements$model[placements$type == "cond"],
              cond_sn = placements$sn[placements$type == "cond"]))
}
