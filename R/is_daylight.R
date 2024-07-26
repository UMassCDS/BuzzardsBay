#' Determine if observation correspond to daylight hours or not
#'
#' @param dt A vector of date times either as text or date time objects
#' @param lat,lon The latitude and longitude of the associated site.
#' @param tz The HOBOware style GMT offset used to define the "timezone" of the
#' dates in `dt`. Probably always "GMT-4:00" but use the value saved to the
#' metadata file.
#'
#' @return A date time object with the dates in `dt` converted to UTC and with
#' that timezone correctly set in the object.
#' @export
is_daylight <- function(dt, lat, lon, tz) {
  utc <- convert_to_utc(dt, tz)
  daytime <- rep(FALSE, length(dt))

  # All the dates in the interval
  dates <- lubridate::as_date(utc) |> unique()

  # Add an extra day to beginning
  # and end to make sure we don't miss any daylight hours, due to using UTC
  dates <- c(min(dates) - 1, dates, max(dates) + 1)
  for (i in seq_along(dates)){
    # Process one data at a time
    date <- dates[i]
    sun_info <- suncalc::getSunlightTimes(date,
                                          lat = lat,
                                          lon = lon,
                                          keep = c("sunrise", "sunset"))
    is_focal_daytime <-  utc > sun_info$sunrise &  utc < sun_info$sunset
    daytime[is_focal_daytime] <- TRUE
  }

  daytime
}
