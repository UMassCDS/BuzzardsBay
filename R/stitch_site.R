'stitch_site' <- function(site_dir, max_gap = 1) {

  #' Stitch all deployments for a site and year
  #'
  #' Merges all QCed deployments for the specified site and year and writes result files. Missing
  #' dates and times are interpolated, with a warning for gaps that are suspiciously large. Data
  #' that are out range for their sensor are flagged. Writes three versions of the data file for the
  #' complete season, and hash files for use by `check_site`.
  #'
  #' Three versions of the data file are written:
  #' 1. archive_<site>_<year>.csv - contains all columns, for complete archival.
  #' 2. WPP_<site>_<year>.csv - contains only columns required by MassDEP (a.k.a. the "WPP" file).
  #' 3. core_<site>_<year> - just the good stuff. This is the file used for producing summaries and reports.
  #'
  #' An additional file is written for internal use by `check_site`:
  #' 2. hash.txt - a tab-delimited file lists paths to deployment files and md5 hashes.
  #'
  #' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`). The path must include QCed results
  #' @param max_gap Maximum gap to quietly accept between deployments (hours); a message will be printed if this gap is exceeded
  #' @importFrom lubridate interval dminutes date duration dhours year yday
  #' @export



  paths <- lookup_site_paths(site_dir, warn = TRUE)
  if(dim(paths$deployments)[1] == 0)
    stop(paste0('There are no valid deployments (both QC and Metadata files) for ', site_dir))

  qc <- lapply(paths$deployments$QCpath, FUN = 'read.csv')                            # Read QC file for each deployment

  all_cols <- get_expected_columns('final_all')                                       # get canonical columns in the right order
  wpp_cols <- get_expected_columns('final_WPP')                                       # can change cols for WPP if wanted; at the moment, it's all columns
  core_cols <- get_expected_columns('final_core')

  t <- basename(paths$deployments$QCpath)                                             # pull deployment names out of paths
  deployments <- sub('\\.csv$', '', tolower(substring(t, regexpr('\\d{4}-\\d{2}-\\d{2}', t))))

  for(i in 1:length(qc)) {                                                            # clean up data: for each deployment,
    qc[[i]][, all_cols[!all_cols %in% names(qc[[i]])]] <- NA                          #    add missing required columns
    qc[[i]] <- qc[[i]][, all_cols]                                                    #    get the columns we want in canonical order and drop the junk

    qc[[i]]$Date_Time <- format_csv_date_time(qc[[i]]$Date_Time, format = 'character')#    reformat dates and dates/times that may have been damaged by Excel
    qc[[i]]$Date <- substring(qc[[i]]$Date_Time, regexpr('\\d{4}-\\d{2}-\\d{2}', qc[[i]]$Date_Time), 10)
  }

  site <- qc[[1]]$Site[1]
  z <- qc[[1]]

  if(length(qc) > 1)                                                                  # if we have more than one deployment in season,
    for(i in 1:(length(qc) - 1)) {                                                    #    Fill gaps: for each pair of deployments,
      x <- c(tail(qc[[i]]$Date_Time, 1), head(qc[[i + 1]]$Date_Time, 1))              #       date of tail of first deployment in pair, head of second one
      x <- as.POSIXct(x)                                                              #       dates to POSIX
      gap <- interval(x[1], x[2]) / dminutes(1)                                       #       gap to fill, in minutes
      m <- yaml::read_yaml(paths$deployments$mdpath[i])$logging_interval_min          #       logging interval of first deployment in pair (min)
      need <- ceiling(gap / m) - 1                                                    #       how many dates do we need to interpolate?
      fill <- x[1] + dminutes(1:need * m)                                             #       here are our interpolated times
      fill <- format(fill, format = '%Y-%m-%d %H:%M:%S')                              #       formatted in the final form

      y <- data.frame(matrix(NA, length(fill), length(all_cols)))                     #       create data frame to fill the gap, with Site, Date, and Date_Time, all others NA
      names(y) <- all_cols
      y$Site <- site
      y$Date <- format(date(fill), format = '%Y-%m-%d')
      y$Date_Time <- fill
      y$Time <- sub('\\d{4}-\\d{2}-\\d{2} ', '', fill)

      z <- rbind(z, y, qc[[i + 1]])                                                   #       build up result: what we've already got, gap fill, and second deployment of pair

      if((d <- duration(gap, units = 'minute')) > dhours(max_gap))                    #       warn if there's a large gap between deployments
        cat('Note: gap between deployments ', deployments[i], ' and ', deployments[i + 1], ' is ', format(d), '\n', sep = '')
    }


  #Add additional columns and put everything in the right order

  x <- read.csv('inst/extdata/sites.csv')                                             #       insert site-level columns from sites.csv
  z$Waterbody <- 123456                 #  ----------------------------ask COMBB to add this to sites file------------------------------
  z$WPP_Station_Identifier <- 123456    #  ---------------------------- "                                 ------------------------------

  if(all(is.na(z$Latitude)))                                                          #       If lat/long aren't present, pull from sites file - only if all missing
  z$Latitude <- x$latitude[x$site == site]
  if(all(is.na(z$Longitude)))
    z$Longitude <- x$longitude[x$site == site]

  z$Unique_ID <- 1:dim(z)[1]                                                          #       unique ID is simply row number
  z$Julian_Date <- yday(z$Date)                                                       #       Julian date, really day in year

  z$Exclude <- 123456                   # TRUE if excluded for any reason (only for 1st 2 files, not core). Pull if any DRs (actually base DR on this)


  # check for values outside of calibration ranges  *** waiting for ranges from COMBBers ****************************************************************************


  # write three versions of data file
  write.csv(z, file = file.path(site_dir, paste0('archive_', site, '_', year(z$Date[1]), '.csv')), row.names = FALSE, quote = FALSE, na = '#N/A')

  # replace rejected values with DR  ********************************************************************************************************************************
  # See Deployment Data Info, tab 4 QC Codes. Rejection column based on Gen_QC. 'DR' for columns with sensor metrics.

  write.csv(z[, wpp_cols], file = file.path(site_dir, paste0('WPP_', site, '_', year(z$Date[1]), '.csv')), row.names = FALSE, quote = FALSE, na = '#N/A')
  write.csv(z[, core_cols], file = file.path(site_dir, paste0('core_', site, '_', year(z$Date[1]), '.csv')), row.names = FALSE, quote = FALSE, na = '')

  x <- paths$deployments$QCpath
  x <- substring(x, regexpr('\\d{4}-\\d{2}-\\d{2}', x))                               # pull relative paths for QC files
  hash <- data.frame(QC = x, hash = paths$deployments$hash)                           # write hashes
  write.table(hash, file = file.path(site_dir, 'hash.txt'), sep = '\t', row.names = FALSE, quote = FALSE)

  cat('\nSite ', site, ' processed for ', year(z$Date[1]), '. There were ', length(qc), ' deployments and a total of ', format(dim(z)[1], big.mark = ','), ' rows.\n', sep = '')
  cat('Results are in ', site_dir, '/\n', sep = '')
}
