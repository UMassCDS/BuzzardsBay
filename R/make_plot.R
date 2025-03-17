#' Produce a time series plot for the final report
#'
#' Produce a time series plot for the final report. Values are plotted as
#' small points, with specified data, x and y columns, and axis labels. A
#' horizontal line can optionally be plotted.
#'
#' @param core Core data frame, produced by `stitch_site`
#' @param x X variable, typically Date_Time
#' @param y Y variable
#' @param x_lab Label for x-axis
#' @param y_lab Label for y-axis
#' @param hline Optional horizontal line at specified value on the y-axis
#' @param point_size Optional size of points in plot
#' @return ggplot2 object
#' @import ggplot2
#' @keywords internal


make_plot <- function(core = core, x = core$Date_Time, y, x_lab, y_lab, hline = 0, point_size = 0.25) {


   ggplot(core, aes(x = x, y = y)) +
      geom_point(size = point_size) +
      labs(x = x_lab, y = y_lab) +
      theme_classic() +
      geom_hline(yintercept = hline, color = 'red', linetype = 2 * (hline != 0))

}
