#' Produce a paired time series plot of DO and Temperature for the final report
#'
#' Produce a paired time series plot of DO and Temperature for the final report.
#' Unlike `make_plot`, this function is specific for a single plot.
#'
#' @param daily daily data frame, from `report_site`
#' @return A ggplot2 object
#' @import ggplot2
#' @importFrom tidyr pivot_longer
#' @importFrom rlang .data
#' @keywords internal


make_facet_plot <- function(daily) {


   daily_long <- daily[, c('Date', 'DO_mean', 'Temp')] |>
      tidyr::pivot_longer(cols = c(.data$DO_mean, .data$Temp))

   y_labels <- as_labeller(c(
      DO_mean = "Dissolved Oxygen (mg/L)",
      Temp = "Water Temperature (C)"
   ))

   ggplot(daily_long, aes(x = .data$Date, y = .data$value)) +
      geom_line(aes(color = .data$name)) +
      facet_grid(name ~ ., scales = 'free_y', switch = 'y', labeller = y_labels) +
      labs(y = 'Metric', x = 'Date') +
      theme_minimal() +
      theme(axis.line.x = element_line(linewidth = 0.3),
            axis.line.y = element_line(linewidth = 0.3)) +
      theme(
         legend.position = 'none',
         strip.placement = 'outside',
         panel.spacing = unit(1.5, 'lines')
      )
}
