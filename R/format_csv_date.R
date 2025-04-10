
#' Format CSV date that might have been corrupted by excel
#'
#' Excel with US localization will automatically convert dates from
#' year-month-day to month/day/year.  Thus whenever a date is read from a
#' CSV that might have been edited with Excel I'm going to check for slashes
#' and assume month/day/year if they are present.
#'
#' @param x Dates as character month/day/year or year-month-day can be
#' mixed in one vector.
#'
#' @return Dates as year-month-day (character)
#' @examples
#' # example code
#' \dontrun{
#' x <- c(NA, "2024-05-15", "2024-05-16", "5/16/2024")
#' }
#' @keywords internal
format_csv_date <- function(x) {
  # Selection vectors for date formats
  mdy_sv <- !is.na(x) & grepl("^[[:digit:]]+/[[:digit:]]+/[[:digit:]]+$", x)
  ymd_sv  <- !is.na(x) & grepl("^[[:digit:]]+-[[:digit:]]+-[[:digit:]]+$", x)
  if (any(!is.na(x) & !mdy_sv & !ymd_sv))
    stop("Some dates weren't parsed properly")

  # Process each format separately
  dates <- rep(NA, length(x))
  if (any(ymd_sv))
    dates[ymd_sv] <- lubridate::ymd(x[ymd_sv]) |> as.character()
  if (any(mdy_sv))
    dates[mdy_sv] <- lubridate::mdy(x[mdy_sv]) |> as.character()
  dates
}



#' Format CSV date that might have been corrupted by excel
#'
#' Excel with US localization will automatically convert dates from
#' year-month-day to month/day/year.  Thus whenever a date is read from a
#' CSV that might have been edited with Excel I'm going to check for slashes
#' and assume month/day/year if they are present.
#'
#' @param x Date times as character month/day/year h:m or year-month-day h:m
#' can be mixed in one vector.  h:m:s is also acceptable in place of h:m
#'
#' @return Dates as year-month-day (character)
#' @examples
#' # example code
#' \dontrun{
#' x <- c(NA, "2024-05-15", "2024-05-16", "5/16/2024")
#' }
#' @keywords internal
format_csv_date_time <- function(x, format = "datetime") {

  if (inherits(x, "POSIXct"))
    return(x)

  # Selection vectors for date formats
  # nolint start: line_length_linter
  mdy_hm_sv <- !is.na(x) & grepl("^[[:digit:]]+/[[:digit:]]+/[[:digit:]]+[[:blank:]]+[[:digit:]]+:[[:digit:]]+$", x)
  ymd_hm_sv  <- !is.na(x) & grepl("^[[:digit:]]+-[[:digit:]]+-[[:digit:]]+[[:blank:]]+[[:digit:]]+:[[:digit:]]+$", x)
  mdy_hms_sv <- !is.na(x) & grepl("^[[:digit:]]+/[[:digit:]]+/[[:digit:]]+[[:blank:]]+[[:digit:]]+:[[:digit:]]+:[[:digit:]]+$", x)
  ymd_hms_sv  <- !is.na(x) & grepl("^[[:digit:]]+-[[:digit:]]+-[[:digit:]]+[[:blank:]]+[[:digit:]]+:[[:digit:]]+:[[:digit:]]+$", x)
  # nolint end: line_length_linter
  if (any(!is.na(x) & !mdy_hm_sv & !ymd_hm_sv & !mdy_hms_sv & !ymd_hms_sv))
    stop("Some date times weren't parsed properly")

  # Process each format separately
  dates <- rep(NA, length(x))
  dates <- lubridate::as_datetime(dates)
  if (any(ymd_hm_sv))
    dates[ymd_hm_sv] <- lubridate::ymd_hm(x[ymd_hm_sv])
  if (any(mdy_hm_sv))
    dates[mdy_hm_sv] <- lubridate::mdy_hm(x[mdy_hm_sv])
  if (any(ymd_hms_sv))
    dates[ymd_hms_sv] <- lubridate::ymd_hms(x[ymd_hms_sv])
  if (any(mdy_hms_sv))
    dates[mdy_hms_sv] <- lubridate::mdy_hms(x[mdy_hms_sv])

  if (format == "datetime")
    return(dates)
  if (format == "character")
    return(format(dates, format = "%Y-%m-%d %T"))
  stop("Unrecognized format argument")
}
