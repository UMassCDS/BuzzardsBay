'stitch_site' <- function(site_dir) {

  #' Stitch all deployments for a site and year
  #'
  #' Merges all QCed deployments for the specified site and year and writes result files. Missing dates and
  #' times are interpolated, with a warning for gaps that are suspiciously large. Data that are out range for
  #' their sensor are flagged. Writes three versions of the data file for the complete season, daily stats,
  #' and hash files for use by `check_site`.
  #'
  #' Three versions of the data file are written:
  #' 1. archive.csv - contains all columns, for complete archival.
  #' 2. share.csv - contains only columns required by MassDEP (a.k.a. the "WPP" file).
  #' 3. core - just the good stuff. This is the file used for producing summaries and reports.
  #'
  #' Two additional files are written:
  #' 1. daily_stats.csv - a file with a row for each day of the season with several summary statistics.
  #' 2. hashes.txt - a file for internal use by `check_site`, this lists full paths to deployment files and
  #' md5 hashes.
  #'
  #' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`). The path must include QCed results.
  #' @export



  paths <- lookup_site_paths(site_dir)
  qc <- lapply(paths$deployments$QCpath, FUN = 'read.csv')                      # Read QC file for each deployment
  cols <- get_expected_columns('qc_final')                                      # get expected column names; we'll dump the rest

  for(i in 1:length(qc)) {                                                      # clean up data: for each deployment,
    qc[[i]] <- qc[[i]][, cols]                                                  #    get the columns we want and drop the junk
    t <- as.POSIXct(format_csv_date_time(qc[[i]]$Date_Time, format = 'datetime'), tz = 'UTC')
    qc[[i]]$Date <- format(t, format = '%Y-%m-%d')                              #    reformat dates and dates/times that may have been damaged by Excel
    qc[[i]]$Date_Time <- format(t, format = '%Y-%m-%d %H:%M:%S')
  }

  z <- qc[[1]]

  if(length(qc) > 1)                                                            # if we have more than one deployment in season,
    for(i in 1:(length(qc) - 1)) {                                              #    Fill gaps: for each pair of deployments,
      x <- c(tail(qc[[i]]$Date_Time, 1), head(qc[[i + 1]]$Date_Time, 1))        #       date of tail of first deployment in pair, head of second one
      x <- as.POSIXct(x)                                                        #       dates to POSIX
      gap <- interval(x[1], x[2]) / dminutes(1)                                 #       gap to fill, in minutes
      m <- yaml::read_yaml(paths$deployments$mdpath[i])$logging_interval_min    #       logging interval of first deployment in pair (min)
      need <- ceiling(gap / m) - 1                                              #       how many dates do we need to interpolate?
      fill <- x[1] + dminutes(1:need * m)                                       #       here are our interpolated times
      fill <- format(fill, format = '%Y-%m-%d %H:%M:%S')                        #       formatted in the final form

      y <- data.frame(matrix(NA, length(fill), length(cols)))                   #       create data frame to fill the gap, with Site, Date, and Date_Time, all else NA
      names(y) <- cols
      y$Site <- qc[[1]]$Site[1]
      y$Date <- format(date(fill), format = '%Y-%m-%d')
      y$Date_Time <- fill
      y$Time <- sub('\\d{4}-\\d{2}-\\d{2} ', '', fill)

      z <- rbind(z, y, qc[[i + 1]])                                             #       build up result: what we've already got, gap fill, and second deployment of pair

     # warn if there's a large gap between deployments
    }

  write.csv(z, file = file.path(site_dir, paste0('archive_', site, '_', year(z$Date[1]), '.csv')), row.names = FALSE, quote = FALSE, na = '')

  # check for values outside of calibration ranges  *** waiting for ranges from COMBBers
  # write 3 data files
  # call daily_stats and write stats file
  # write hash file
  # say what we just did


}
