report_site <- function(site_dir, check = TRUE) {

  #' Produce stats and a report for a site and year
  #'
  #' Produces daily stats and a report with seasonal stats and a number of graphs for a specified site and year.
  #'
  #' Two files are written:
  #' 1. `daily_stats_<site>_<year>.csv` - a file with a row for each day of the season with several summary statistics
  #' 2. `report_<site>_<year>.pdf` - a PDF report with a table of seasonal stats and a number of graphs
  #'
  #' `stitch_site` must be run first to create the necessary data. If `stitch_site` was run at
  #' some point in the past, it is highly advisable to run `check_site` to make sure deployment
  #' files haven't changed since the last `stitch_site` run.
  #'
  #' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`)
  #' @param check If TRUE, runs `check_site` to make sure source files haven't been changed
  #' @export



  if(check) {
    if(!check_site(site_dir))
      stop('check_site failed. Address the issues or rerun report_site with check = FALSE.')
    else
      msg('')
  }


  site <- basename(site_dir)
  year <- basename(dirname(site_dir))

  core <- read.csv(file.path(site_dir, paste0('combined/core_', site, '_', year, '.csv')))

  daily <- daily_stats(site, year, core)                                                  # calculate daily stats
  f <- file.path(site_dir, paste0('combined/daily_stats_', site, '_', year, '.csv'))
  write.csv(daily, file = f, row.names = FALSE, quote = FALSE, na = '')
  msg('Daily stats written to ', f)


  # seasonal <- seasonal_stats(...)                                              *****    # calculate seasonal stats

  # *** now do plots............



  f <- file.path(site_dir, paste0('combined/report_', site, '_', year, '.csv'))

  # ***** write PDF

  msg('Seasonal report written to ', f)
}
