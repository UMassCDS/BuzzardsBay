

#' Get the tide height at a particular station corresponding to a series
#' of date, times.
#'
#' `get_tide_height()` is a wrapper to [rtide::tide_height()] that works
#' with a date time vector and also checks the station against
#' `tide_station_info`.
#'
#' @param dt Series of date-time values as POSIXct. The time zone must be
#' properly set.
#' @param station A station name or station ID as it appears in
#' [tide_station_info].
#'
#' @return A series of tide heights corresponding to the date-times in `dt`
#' Heights are in meters and, I think, are relative to
#' [MLLW](https://tidesandcurrents.noaa.gov/datum_options.html#MLLW)
#' (Mean Lower Low  Water). Although, I could only find this stated about
#' individual stations and not for all stations in general.
#'
#' See for example the datum information for
#' [PENIKESE ISLAND MA](https://tidesandcurrents.noaa.gov/datums.html?id=8448248),
#' which states "NOTICE: All data values are relative to the MLLW.".
#'
#'
get_tide_height <- function(dt, station) {

  if (!inherits(dt, "POSIXct"))
    stop("Exptected dt to be a POSIXct date time object")

  tz <- lubridate::tz(dt)

  # Logging interval in minutes
  interval <- difftime(dt[2], dt[1], units = "mins") |> as.numeric()


  tsi <- tide_station_info
  stopifnot(length(station) == 1)
  if (station %in% tsi$name) {
    station <- tsi$id[tsi$name == station]
  }
  if (!station %in% tsi$id) {
    stop("Station ", station, " is not a station id or name in tide_station_info")
  }
  station
  station_name <- tsi$name[tsi$id == station]

  from_day <- lubridate::as_date(dt[1])
  to_day <- lubridate::as_date(dplyr::last(dt))

  tide <- rtide::tide_height(stations = station_name, from = from_day,
                             to = to_day, tz = tz, minutes = interval)
  tide <- tide[ , c("DateTime", "TideHeight")]
  names(tide) <- c("Date_Time", "Tide_Height")

  stopifnot(all(dt %in% tide$DateTime))
  res <- dplyr::left_join(data_frame(Date_Time = dt), tide)
  stopifnot(all(res$Date_Time == dt))
  return(res$Tide_Height)
}
