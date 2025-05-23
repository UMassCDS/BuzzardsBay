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
#' Including plots based on Baywatchers data requires a file within the site `baywatchers/<site>.csv`. This file must
#' include the date and time (a column that includes `Date_Time` in the name) and dissolved oxygen in mg/L (DO in the
#' name, but not percent, pct, or %). Column names are case-insensitive. If this file is missing or the necessary
#' columns are not present, an error will be reported. You can use `baywatchers = FALSE` for datasets that don't have
#' Baywatchers data to exclude these plots.
#'
#' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`)
#' @param check If TRUE, runs `check_site` to make sure source files haven't been changed
#' @param baywatchers If TRUE, do 2 additional comparison plots with Baywatchers data
#' @importFrom lubridate as.period as.duration days
#' @importFrom slider slide_index_mean
#' @importFrom readxl read_excel
#' @importFrom hms as_hms
#' @export


report_site <- function(site_dir, check = TRUE, baywatchers = TRUE) {


   if(check) {
      if(!check_site(site_dir, check_report = FALSE, check_baywatchers = baywatchers))
         stop('check_site failed. Address the issues or rerun report_site with check = FALSE.')
      else
         msg('')
   }

   if (!requireNamespace('tinytex', quietly = TRUE)) {
      install.packages('tinytex')
      tinytex::install_tinytex()
   }


   site <- toupper(basename(site_dir))
   year <- basename(dirname(site_dir))

   core <- read.csv(file.path(site_dir, paste0('combined/core_', site, '_', year, '.csv')))


   # --- Daily stats
   daily_stats <- daily_stats(core)                                                       # calculate daily stats

   core$Date <- as.POSIXct(core$Date)                                                     # we'll need date and date/time as time objects
   core$Date_Time <- as.POSIXct(core$Date_Time)

   # --- Seasonal stats
   seasonal <- seasonal_stats(core)                                                       # calculate seasonal stats

   # For daily stats, we're dropping days with <22/24 hours of data, as well as first and last days
   x <- cbind(min = aggreg(core$DO, by = core$Date, FUN = min, nomiss = 22 / 24, drop_by = FALSE),
              max = aggreg(core$DO, by = core$Date, FUN = max, nomiss = 22 / 24))
   daily <- data.frame(Date = x$min.Group.1, DO_range = x$max - x$min.x, DO_min = x$min.x)
   daily$DO_range[!is.finite(daily$DO_range)] <- NA                                       # daily range of DO

   daily$DO_count <- aggreg(!is.na(core$DO), by = core$Date, FUN = sum, nomiss = 22 / 24)
   daily$DO_6 <- aggreg(core$DO < 6, by = core$Date, FUN = sum, nomiss = 22 / 24)
   daily$DO_6_pct <- daily$DO_6 / daily$DO_count * 100

   daily$salinity <- aggreg(core$Salinity, by = core$Date, FUN = mean, nomiss = 22 / 24)

   daily$DO_mean <- aggreg(core$DO, by = core$Date, FUN = mean, nomiss = 22 / 24)
   daily$Temp <- aggreg(core$Temp_CondLog, by = core$Date, FUN = mean, nomiss = 22 / 24)

   daily <- daily[c(-1, -dim(daily[1])), ]                                                # drop partial 1st and last day of season


   # Moving window plot
   halfwin <- as.period(as.duration(days(7)) / 2)
   core$rolling_do <- unlist(slide_index_mean(core$DO, core$Date_Time, na_rm = TRUE, before = halfwin, after = halfwin))
   core$rolling_do[is.na(core$DO)] <- NA                                                  # *** if DO is missing, set rolling DO to missing too


   # --- Get Baywatchers data now before we've written any results (in case of errors)
   if(baywatchers) {                                                                      # if they want Baywatchers plots,
      f <- file.path(dirname(site_dir), 'baywatchers.csv')                                #    read the data
      if(!file.exists(f))
         stop(paste0('Baywatchers file ', f, ' doesn\'t exist.\nYou can exclude Baywatchers data with baywatchers = FALSE or recreate it with extract_baywatchers.'))
      x <- read.csv(f)
      bay <- x[x$Site == site & !is.na(x$DO), ]
      bay$Date_Time <- as.POSIXct(bay$Date_Time)
      bay <- bay[bay$Date_Time >= core$Date_Time[1] &
                    bay$Date_Time <= core$Date_Time[dim(core)[1]], ]                      # trim Baywatchers to date range of sensor data ***
      bay$Sensor_DO <- approx(core$Date_Time, core$DO, bay$Date_Time)$y                   # interpolate sensor data for Fig. 11
      if(dim(bay)[1] == 0) {
         msg('There are no Baywatchers data for this site and year. Omitting Figs. 10 and 11')
         baywatchers <- FALSE
      }
   }


   # --- Put together PDF report
   template <- system.file('rmd/seasonal_report.rmd', package = 'BuzzardsBay', mustWork = TRUE)
   report_file <- file.path(site_dir, 'combined', paste0('report_', site, '_', year, '.pdf'))
   abs_report_file <- file.path(normalizePath(file.path(site_dir, 'combined')), paste0('report_', site, '_', year, '.pdf'))

   long_site <- get_site_name(site_dir)
   title <- paste0(long_site, ' (', site, ') in ', year)
   date <- sub(' 0', ' ', format(Sys.Date(), '%B %d, %Y'))


   plot_info <- read.table(system.file('extdata/plot_info.txt', package = 'BuzzardsBay',  # read plot info table
                                       mustWork = TRUE), sep = '\t', header = TRUE)
   rownames(plot_info) <- plot_info$name


   pars <- list(title = title, date = date, stat = seasonal$stat, value = seasonal$value)


   rmarkdown::render(input = template, output_file = abs_report_file,                     # write PDF (have to use absolute path here 😡)
                     params = pars, quiet = TRUE)

   msg('Seasonal report written to ', report_file)


   # --- Write daily stats
   f <- file.path(site_dir, paste0('combined/daily_stats_', site, '_', year, '.csv'))
   write.csv(daily_stats, file = f, row.names = FALSE, quote = FALSE, na = '')
   msg('Daily stats written to ', f)


   x <- get_file_hashes(file.path(site_dir, 'combined/hash.txt'))
   writeLines(x, file.path(site_dir, 'combined/report_hash.txt'))                         # write report hash, used to see if reports are up to date in check_site
}
