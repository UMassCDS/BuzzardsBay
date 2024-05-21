


#' Interactive logger data plot
#'
#' See the rmarkdown document
#' included with the package for example usage, found by running:
#' `system.file("rmd/QAQC_report.Rmd", package = "BuzzardsBay")`.
#'
#' `bb_interactive_plot()` uses the **plotly** package to make an interactive
#' plot of data from a Buzzard's Bay logger deployment.
#' @param focal_column A single column from `d`
#' @inheritParams bb_plot
#'
#' @return A plotly plot object.
#'
#' @export
bb_interactive_plot <- function(d,
                                dl,
                                focal_column,
                                jump_pattern,
                                focal_flag_pattern,
                                plot_label,
                                focal_flag_label = plot_label,
                                y_label,
                                threshold_values,
                                threshold_labels,
                                threshold_colors) {

  interval <- d$Date_Time[2] - d$Date_Time[1]

  # Generate data frame for the current flag rectangles
  d$current_flag <- grepl(focal_flag_pattern, d$Flags)
  flag_dt <- d$Date_Time[d$current_flag] # date time of each flag center
  x0s <- flag_dt - 0.5 * interval # start of each flag
  x1s <- flag_dt + 0.5 * interval # end pf each flag
  flag_rectangles <- vector(mode = "list", length = length(x0s))
  for (i in seq_along(x0s)) {
    flag_rectangles[[i]] <- list(type = "rect",
                                 x0 = x0s[i],
                                 x1 = x1s[i],
                                 y0 = -1000,
                                 y1 = 1000,
                                 fillcolor = "red",
                                 line = list(width = 0),
                                 opacity = 0.3)
  }

  # Generate data frame for other flags
  d$other_flags <- !is.na(d$Flags) & !d$current_flag

  flag_dt <- d$Date_Time[d$other_flags] # date time of each flag center
  x0s <- flag_dt - 0.5 * interval # start of each flag
  x1s <- flag_dt + 0.5 * interval # end pf each flag
  other_flag_rectangles <- vector(mode = "list", length = length(x0s))
  for (i in seq_along(x0s)) {
    other_flag_rectangles[[i]] <- list(type = "rect",
                                       x0 = x0s[i],
                                       x1 = x1s[i],
                                       y0 = -1000,
                                       y1 = 1000,
                                       fillcolor = "orange",
                                       line = list(width = 0),
                                       opacity = 0.3)
  }

  all_flag_rectangles <- c(flag_rectangles, other_flag_rectangles)


  # Determine range of the focal data and critical thresholds
  yrange <- range(d[[focal_column]])

  # Assemble plot
  p <- plotly::plot_ly(d,
                       x = ~Date_Time,
                       y = ~.data[[focal_column]], type = "scatter",
                       mode = "lines",
                       name = plot_label)

  for (i in seq_along(threshold_values)) {
    p <- p |>
      plotly::add_trace(y = threshold_values[i],
                        name = threshold_labels[i],
                        line = list(color = threshold_colors[i], dash = "dash"))

  }

  p <- p |>
    plotly::layout(xaxis = list(title = "Date/Time"),
                   yaxis = list(title = y_label,
                                range = yrange),
                   shapes = all_flag_rectangles)

  return(p)

}
