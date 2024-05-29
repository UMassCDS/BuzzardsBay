#' Convert date-time text to date time object in UTC
#'
#' `convert_to_gmt()`  Takes date time text in <year>-<month>-<day> h:m:s and
#' for a "timezone" expressed as an offset from UTC/GMT and converts it into
#' a UTC time.
#'
#' HOBOware is configured to log the time based on an offset from GMT and
#' it stores that offset.  This takes the time with the offset and removes the
#' offset to get it back to GMT and converts to a date time object with the
#' GMT timezone.
#
#'
#' @param dt One or more date time strings e.g. "2024-05-28 3:30:00"
#' @param tz A timezone like thing expressing the offset from GMT e.g.
#' "GMT-4:00"  This is the format used by hoboware and saved into the metadata
#' object and file.
#' @return A date time object in UTC it will be offset from
#' the local "timezone".
#'
#' @examples
#' convert_to_utc("2024-05-28 3:30:00", "GMT-4:00")
#'
convert_to_gmt <- function(dt, tz){


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
    min <- gsub("^[+-][[:digit:]]+:([[:digit:]]+)*", "\\1", offset, perl = TRUE) |>
      as.numeric()
    offset_seconds <- hrs * 3600 + min * 60
    if(sign == "+")
      offset_seconds <- 0 - offset_seconds
    offset_difftime <- as.difftime(offset_seconds, units = "secs")

    # Convert to date time with GMC/UTC timeszone this will be off by the offset
    dt <- lubridate::as_datetime(dt,  tz = "gmt")

    # Adjust with offset to get proper UTC time
    return(dt + offset_difftime)

}
