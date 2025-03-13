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


report_site <- function(site_dir, check = TRUE) {


  if(check) {
    if(!check_site(site_dir, check_report = FALSE))
      stop('check_site failed. Address the issues or rerun report_site with check = FALSE.')
    else
      msg('')
  }


  site <- toupper(basename(site_dir))
  year <- basename(dirname(site_dir))

  core <- read.csv(file.path(site_dir, paste0('combined/core_', site, '_', year, '.csv')))

  core <<- core  # ********** for dev



  # --- Daily stats
  daily <- daily_stats(core)                                                            # calculate daily stats
  f <- file.path(site_dir, paste0('combined/daily_stats_', site, '_', year, '.csv'))
  write.csv(daily, file = f, row.names = FALSE, quote = FALSE, na = '')
  msg('Daily stats written to ', f)


  # --- Seasonal stats
  seasonal <- seasonal_stats(core)                                                      # calculate seasonal stats


  # --- Plots
 ## plots <- seasonal_plots(core)                                                         # get plots



  # --- Put together PDF report
  template <- system.file('rmd/seasonal_report.rmd', package = 'BuzzardsBay', mustWork = TRUE)
  report_file <- file.path(site_dir, 'combined', paste0('report_', site, '_', year, '.pdf'))
  abs_report_file <- file.path(normalizePath(file.path(site_dir, 'combined')), paste0('report_', site, '_', year, '.pdf'))

  long_site <- get_site_name(site_dir)
  title <- paste0(long_site, ' (', site, ') in ', year)
  date <- sub(' 0', ' ', format(Sys.Date(), '%B %d, %Y'))

  pars <- list(title = title, date = date, stat = seasonal$stat, value = seasonal$value)


  rmarkdown::render(input = template, output_file = abs_report_file,                    # write PDF (have to use absolute path here 😡)
                         params = pars, quiet = TRUE)

  msg('Seasonal report written to ', report_file)



  x <- get_file_hashes(file.path(site_dir, 'combined/hash.txt'))
  writeLines(x, file.path(site_dir, 'combined/report_hash.txt'))                        # write report hash, used to see if reports are up to date in check_site
}
