#' Produce a time series plot with two datasets for the final report
#'
#' Produce a time series plot for the final report that includes 2 sets of variables. Values
#' in first set are plotted as small black points, and those in second set as larger red points,
#' plotted on top of the first.
#'
#' @param data1 First dataset
#' @param x1 First X variable
#' @param y1 First Y variable
#' @param data1 Second dataset
#' @param x1 Second X variable
#' @param y1 Second Y variable
#' @param x_lab Label for x-axis
#' @param y_lab Label for y-axis
#' @return A ggplot2 object
#' @import ggplot2
#' @keywords internal


make_plot_2var <- function(data1, data2, x1, y1, x2, y2, x_lab, y_lab) {


   ggplot() +
      geom_point(data = data1, aes(x = x1, y = y1), size = 0.5, color = 'black') +
      geom_point(data = data2, aes(x = x2, y = y2), size = 1.5, color = 'red') +

      labs(x = x_lab, y = y_lab) +
      theme_minimal() +
      theme(axis.line.x = element_line(linewidth = 0.3),
            axis.line.y = element_line(linewidth = 0.3))
}
