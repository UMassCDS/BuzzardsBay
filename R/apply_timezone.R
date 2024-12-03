#' Apply at timezone to a date time string or object
#'
#' `apply_timezone()`  Takes date time text in <year>-<month>-<day> h:m:s and
#' a separate "timezone" expressed as an offset from UTC/GMT or as a real
#' timezone and convert to a date-time object with a timezone.
#'
#' HOBOware is configured to log the time based on an offset from GMT.
#' The BuzzardsBay package stores that "timezone", but the offset isn't a valid
#' timezone. This gets around that by adding the offset hours and then defining
#' the timezone as "UTC" - thus the points are correctly located in time - but
#' not in the local timezone.
#'
#' More recent ONSET software uses a valid time zone ("EDT") and for data
#' processed with this software that timezone is recorded in the metadata.
#' For these timezones `apply_timezone()` simply returns the date-times
#' in `dt` with `tz` specified.
#'
#' For plotting convert the string to a date-time object without specifying
#' the timezone and ignore the default (UTC) timezone and thus do NOT use
#' this function.
#'
#' However, for some uses it's important that the times are fully and correctly
#' defined. For example to looking up the correct sunrise and sunset times,
#' or tide charts. For these uses it's not actually important that its in the
#' local timezone and so UTC with the offset applied is fine, as long as the
#' resulting object correctly identifies when the data was collected.
#'
#' @param dt One or more date time strings e.g. "2024-05-28 3:30:00" or
#' a date object made from such a string without specifying the timezone.  In
#' the later case the listed times should be in the timezone indicated by `tz`,
#' but quite possibly the defined timezone of the date time object won't be
#' correct.
#' @param tz Either (1) "timezone" string expressing the offset from GMT e.g.
#' "GMT-4:00"- this is the format used by HOBOware and saved into the metadata
#' object and file, but is not a standard timezone; or (2) a standard time
#' zone e.g. "EDT" as appears in other calibrated files.
#' @return A date time object in with a defined timezone that together locates
#' the observations correctly in time (but may not be in the local timezone).
apply_timezone <- function(dt, tz) {

  # I've been storing the time as a date time string without any timezone,
  #  dodging a big timezone headache, for most cases.

  # The "timezone" as defined by ONSET is saved in md$timeszone.

  # The Hoboware timezone is relative to GMT: "GMT-4:00
  # which isn't a valid timezone on my system. Other ONSET software does use
  # a valid timezone (EDT).

  # This function handles both timezone specifications but in the offset case
  # the date-time is changed to it's UTC equivalent.

  uses_offset <- grepl("^GMT[+-][[:digit:]]+:[[:digit:]]+", tz)

  if (uses_offset) {
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
  } else {
    # This assumes tz is a valid timezone and will fail if it's not
    return(as.character(dt) |> lubridate::as_datetime(tz = tz))
  }

}
