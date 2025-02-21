'report' <- function(site_dir) {



  #' 1. daily_stats.csv - a file with a row for each day of the season with several summary statistics.





  stats <- data.frame(matrix(1:15, 5, 3, byrow = TRUE))
  names(stats) = c('one', 'two', 'three')
  #  stats <- daily_stats(...)                                                        # calculate daily stats *********************************************************
  write.csv(stats, file = file.path(site_dir, paste0('daily_stats_', site, '_', year(z$Date[1]), '.csv')), row.names = FALSE, quote = FALSE, na = '')






}
