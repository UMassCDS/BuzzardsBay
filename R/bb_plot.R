
#' Make static plot of logger data
#'
#' `bb_plot()` uses **gplot2** to generate plots of logger data. It is
#' primarily intended for use in reports.
#' See the rmarkdown document
#' included with the package for example usage, found by running:
#' `system.file("rmd/QAQC_report.Rmd", package = "BuzzardsBay")`.
#'
#' @param d Data frame with logger data as produced by [qc_deployment()]
#' @param dl Long version of the same data.
#' @param focal_columns Names of columns in `d` that should be plotted,
#'                      max of 2 and they should have comparable scales.
#' @param jump_pattern Regular expression to identify jump flags for the
#'                     focal columns.
#' @param focal_flag_pattern Regular expression to identify all flags for
#'                      the focal columns
#' @param err_pattern Regular expression to identify flags that indicate a
#' sensor error code (typically value of -888.88) these values will be excluded
#' when setting the y axis range.
#' @param plot_label  Label for the plot.
#' @param focal_flag_label  Label for the focal flag, " Flag" will be appended.
#' @param y_label Y axis label.
#' @param threshold_values One or more threshold values to be plotted as
#' horizontal lines.
#' @param threshold_labels The labels (text) to use for the threshold lines,
#' one per `threshold_value`.
#' @param threshold_colors The color to use for the threshold lines, can be
#' one color or a color for each `threshold_value`.
#' @param lat,lon The latitude and longitude of the site, used to calculate
#'                sunrise and sunset times.
#' @param range_limit The plot range will never exceed this range - it can
#' be more restricted.
#' @return A ggplot plot object. Use `print()` to turn it into a plot/
#' @importFrom rlang .data
#' @importFrom grDevices rgb
#' @export
bb_plot <- function(d,
                    dl,
                    focal_columns,
                    jump_pattern,
                    focal_flag_pattern,
                    err_pattern,
                    plot_label,
                    focal_flag_label = plot_label,
                    y_label,
                    threshold_values,
                    threshold_labels,
                    threshold_colors,
                    lat = NULL,
                    lon = NULL,
                    range_limit = c(NA, NA)) {

  #----------------------------------------------------------------------------#
  # Hard coded variables
  #----------------------------------------------------------------------------#

  # Set time of day (background colors)
  tod_colors <- c(rgb(1, 1, 1, .8), rgb(0, 0, 0, .04))
  tod_color_labels <- c("Day", "Night")

  # set flag colors
  flag_colors <- c(rgb(1, 0, 0, .3), rgb(1, 0.5, 0, 0.3))
  flag_color_labels <- c(paste0(focal_flag_label, " Flag"), "Other Flag")

  # Set line colors
  line_colors <- c(rgb(0, 0, 0, .9), rgb(0, 0, 1, .9))

  # Middle of x range
  x_mid <- mean(range(d$Date_Time))

  # If FALSE then thresholds are only plotted (as horizontal lines)
  # when they are exceeded.  This prevents the extent of the plot
  # from being extended beyond the range of the actual data.
  always_plot_thresholds <- FALSE

  #----------------------------------------------------------------------------#
  # Additional data prep
  #----------------------------------------------------------------------------#


  if (length(threshold_colors) == 1 && !length(threshold_values == 1))
    threshold_colors <- rep(threshold_colors, length(threshold_values))

  # Assemble jump points
  dl$jumped <- grepl(jump_pattern, dl$Flags)
  jump_points <- dl[dl$jumped & dl$name %in% focal_columns, , drop = FALSE]

  d$Time_of_Day <- ifelse(d$daylight, "Day", "Night")
  d$tod_color <- ifelse(d$Time_of_Day == "Day", tod_colors[1], tod_colors[2])

  # Add flag color column
  dl$Any_Flag <- !is.na(dl$Flags)
  dl$This_Flag <- grepl(focal_flag_pattern, dl$Flags)
  dl$flag_col <- NA
  dl$flag_col[dl$Any_Flag] <- flag_colors[2]
  dl$flag_col[dl$This_Flag]  <- flag_colors[1]


  # Drop rows not associated with current data columns
  dl <- dplyr::filter(dl, .data$name %in% focal_columns)

  # Add error column for rows that had a sensor error
  dl$sensor_error <- grepl(err_pattern, dl$Flags)

  # Calculate range of data (excluding errors)
  focal_range <- range(dl$value[!dl$sensor_error])

  # Constrain to range limit
  focal_range[1] <- max(focal_range[1], range_limit[1], na.rm =  TRUE)
  focal_range[2] <- min(focal_range[2], range_limit[2], na.rm = TRUE)

  #----------------------------------------------------------------------------#
  # Assemble plot
  #----------------------------------------------------------------------------#

  p <-  dl |>
    ggplot2::ggplot(ggplot2::aes(x = .data$Date_Time,
                                 y = .data$value,
                                 color = .data$name))

  # Add Rectangles for night and day
  suppressWarnings({  # lead() creates NA resulting in warning
    p <- p +
      ggplot2::geom_rect(data = d,
                         ggplot2::aes(xmin = .data$Date_Time,
                                      xmax = dplyr::lead(.data$Date_Time),
                                      ymin = -Inf,
                                      ymax = Inf,
                                      fill = .data$tod_color),
                         inherit.aes = FALSE) +

      # Add Rectangles for flags
      ggplot2::geom_rect(ggplot2::aes(xmin = .data$Date_Time,
                                      xmax = dplyr::lead(.data$Date_Time),
                                      ymin = -Inf,
                                      ymax = Inf,
                                      fill = .data$flag_col),
                         inherit.aes = FALSE)
  })

  background_cols <- c(tod_colors, flag_colors)
  background_labels <- c(tod_color_labels, flag_color_labels)

  # Add lines with DO
  p <- p + ggplot2::geom_line(size = .35) +
    ggplot2::scale_color_manual(values = line_colors, name = NULL)


  # Add thresholds to plot if they are within the range of the data
  # These are horizontal lines indicating maximum or minimum value before
  # a flag is set




  for (i in seq_along(threshold_values)) {
    plot_it <- always_plot_thresholds ||
      (focal_range[2] > threshold_values[i] &&
         focal_range[1] < threshold_values[i])

    if (plot_it) {
      p <- p +  ggplot2::geom_hline(yintercept = threshold_values[i],
                                    color = threshold_colors[i]) +
        ggplot2::annotate("text",
                          x = x_mid,
                          y = threshold_values[i],
                          label = threshold_labels[i],
                          vjust = -.5,
                          color = threshold_colors[i])
    }
  }

  # Add Jump points
  if (nrow(jump_points) > 0) {
    p <- p + ggplot2::geom_point(ggplot2::aes(x = .data$Date_Time,
                                              y = .data$value,
                                              color = .data$name),
                                 data = jump_points,
                                 inherit.aes = FALSE,
                                 show.legend = FALSE)
  }

  # Indicate end of prior deployment
  if (any(dl$Prior_Dep)) {


    last_prior <- max(d$Date_Time[d$Prior_Dep]) # end of prior deployment
    first <- min(d$Date_Time[!d$Prior_Dep])  # beginning of current deployment

    sv <- dl$Date_Time %in% c(last_prior, first) & dl$name %in% focal_columns
    cp <- dl[sv, , drop = FALSE]


    p <- p + ggplot2::geom_point(data = cp,
                                 ggplot2::aes(x = .data$Date_Time,
                                              y = .data$value),
                                 inherit.aes = FALSE,
                                 show.legend = FALSE,
                                 size = 2.25,
                                 shape = 1,
                                 color = "red")


  }

  # This adds the background color boxes to the legend
  p <- p +
    ggplot2::scale_fill_identity(name = NULL,
                                 breaks = background_cols,
                                 labels = background_labels,
                                 guide = "legend")




  # Title and axis labels
  p <- p +
    ggplot2::ggtitle(plot_label) +
    ggplot2::ylab(y_label) +
    ggplot2::xlab(NULL)

  # Limit y axis without dropping data
  p <- p + ggplot2::coord_cartesian(ylim = focal_range)

  return(p)
}
