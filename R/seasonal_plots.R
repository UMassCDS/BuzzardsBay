#' Produce seasonal plots for a site
#'
#' Produces a list with a series of seasonal plots as ggplot2 objects.
#'
#' @param core Core data frame, produced by `stitch_site`
#' @return List of ggplot2 objects
#' @import ggplot2
#' @keywords internal


seasonal_plots <- function(core) {

   core$Date_Time <- as.POSIXct(core$Date_Time)

ggplot(core, aes(x = Date_Time, y = DO)) +
   geom_line()




}
