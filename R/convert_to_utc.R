#' Convert the local date-time text or date object to the equivalent date time
#' in UTC with a correctly defined (UTC) timezone.
#'
#' `convert_to_utc()`  Takes date time text in <year>-<month>-<day> h:m:s and
#' a separate "timezone" expressed as an offset from UTC/GMT and converts the
#' date times into UTC.
#'
#' HOBOware is configured to log the time based on an offset from GMT.
#' The BuzzardsBay package stores that "timezone", but the offset isn't a valid
#' timezone. This gets around that by adding the offset hours and then defining
#' the timezone as "UTC".
#'
#' For plotting I just use the local time so this isn't necessary, but the UTC
#' times are necessary for looking up the correct sunrise and sunset times.
#'
#' @param dt One or more date time strings e.g. "2024-05-28 3:30:00" or
#' a date object made from such a string without specifying the timezone.  It
#' should be in the "timezone" indicated by `tz`.
#' @param tz A "timezone" string expressing the offset from GMT e.g.
#' "GMT-4:00"  This is the format used by HOBOware and saved into the metadata
#' object and file, but is not a standard timezone.
#' @return A date time object in UTC that corresponds to the input time
#' (in `tz`).
convert_to_utc <- function(dt, tz) {


  # I've been storing the time as a date time string without any timezone.
  # This affectively dodges a big timezone headache.


  # and saving the hoboware "timezone" in md$timeszone.

  # The Hoboware timezone is relative to GMT: "GMT-4:00
  # which isn't a valid timezone on my system.

  # Here I convert the time as recorded to UTC/GMT and then add the
  # offset as a difftime to get the actual UTC time.

  # Check to make sure hoboware is still using a GMT offset
  stopifnot(grepl("^GMT[+-][[:digit:]]+:[[:digit:]]+", tz))
  offset <- gsub("^GMT", "", tz)

  # Convert offset to a difftime
  sign <- gsub("^([+-]).*$", "\\1", offset, perl = TRUE)
  hrs <- gsub("^[+-]([[:digit:]]+):.*", "\\1", offset, perl = TRUE) |>
    as.numeric()
  min <- gsub("^[+-][[:digit:]]+:([[:digit:]]+)*", "\\1",
              offset, perl = TRUE) |> as.numeric()
  offset_seconds <- hrs * 3600 + min * 60
  if (sign == "+")
    offset_seconds <- 0 - offset_seconds
  offset_difftime <- as.difftime(offset_seconds, units = "secs")

  # Convert to date time with GMC/UTC timeszone this will be off by the offset
  dt <- lubridate::as_datetime(dt,  tz = "UTC")

  # Adjust with offset to get proper UTC time
  return(dt + offset_difftime)

}
