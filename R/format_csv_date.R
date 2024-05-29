
#' Format CSV date that might have been corrupted by excel
#'
#' Excel with US localization will automatically convert dates from
#' year-month-day to month/day/year.  Thus whenever a date is read from a
#' csv that might have been edited with Excel I'm going to check for slashes
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
