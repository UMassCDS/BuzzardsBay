#' Plot tide height and daylight hours
#'
#' `plot_tide_sun()`  Creates a plot with vertical background stripes
#' indicating daylight hours and a line indicating tide height.  Due to a
#' limitation in **rtide** it doesn't work with most of the Buzzards Bay tide
#' stations.
#'
#' @param d A data frame containing the DO and other data for which a
#' companion Daylight and Tide height plot is needed.  Only the column
#' `Date_Time` is used BUT it is assumed that the interval between observations
#' is consistent in the file.
#' @param station The tide station name for which the plot should be made
#' @param lat,lon The latitude and longitude of the site - used for daylight
#' hour calculations.
#' @param tz The HOBOware style "timezone" associated with the `Date_Time`
#' column e.g. "GMT-4:00".  Note, in general in the BuzzardsBay package
#' Date Time objects are stored as a string "2024-05-31 6:00:00"  or converted
#' to a POSIX object WITHOUT a defined timezone.  The "Timezone" as used by
#' HOBOware is saved in the metadata object and is an offset from GMT/UTC
#' and NOT a TRUE timezone.  Passing this offset as `tz` allows the local date
#' times to to be converted to their UTC equivalent and the UTC timezone to be
#' set such that they represent an accurate time + timezone for use with
#' tide chart and daylight hour lookup.
plot_tide_sun <- function(d, station, lat, lon, tz) {

  # Date time stuff is annoying.
  # Most of the time I'm using the Date Time as originally defined in the
  # HOBOware output files and store it as a string.
  # When reading these values readr::read_csv() defaults to UTC even though
  # they are not in that timezone and for most purposes that's fine because
  # the times themselves are preserved and they are the times I want to plot
  # and the timezone doesn't show up in the plot.


  # However for the purposes of looking up tide, sunrise, and sunset
  # I need to have the timezone properly set, so I take those times and
  # convert them to correct UTC equivalent based on the psuedo-timezone
  # that HOBOware uses  - an offset from GMT - see apply_timezone()

  # Then I plot the tide and daylight hours using the original date times
  # which still represent the local time.

  tide_sun  <- data.frame(Date_Time = sort(unique(d$Date_Time)))
  tide_sun$utc <- apply_timezone(tide_sun$Date_Time, tz)


  tide_sun$Tide_Height <- get_tide_height(tide_sun$utc, station = station)


  tide_sun$daytime <- is_daylight(tide_sun$Date_Time, lat, lon, tz)
  # Set time of day (background colors)
  tod_colors <- c(rgb(1, 1, 1, .25), rgb(0, 0, 0, .25))
  tod_color_labels <- c("Day", "Night")


  tide_sun$tod_color <- tod_colors[2]
  tide_sun$tod_color[tide_sun$daytime] <- tod_colors[1]




  ggplot2::ggplot(data = tide_sun, ggplot2::aes(x = .data$Date_Time,
                                                y = .data$Tide_Height)) +
    ggplot2::geom_line(color = "blue") +
    ggplot2::xlab(label = NULL) +
    ggplot2::ylab("Tide Height (m)") +
    ggplot2::geom_rect(ggplot2::aes(xmin = .data$Date_Time,
                                    xmax = dplyr::lead(.data$Date_Time),
                                    ymin = -Inf,
                                    ymax = Inf,
                                    fill = .data$tod_color),
                       inherit.aes = FALSE) +

    ggplot2::scale_fill_identity(name = NULL,
                                 breaks = c(tod_colors),
                                 labels = c(tod_color_labels),
                                 guide = "legend")

}
