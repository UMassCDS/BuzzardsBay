stitch_site <- function(site_dir, max_gap = 1, report = FALSE) {

   #' Stitch all deployments for a site and year
   #'
   #' Merges all QCed deployments for the specified site and year and writes result files. Missing
   #' dates and times are interpolated, with a warning for gaps that are suspiciously large. Data
   #' that are out range for their sensor are flagged. Writes three versions of the data file for the
   #' complete season, and hash files for use by `check_site`.
   #'
   #' Three versions of the data file are written to <site_dir>/combined/:
   #' 1. `archive_<site>_<year>.csv` - contains all columns, for complete archival.
   #' 2. `WPP_<site>_<year>.csv` - contains only columns required by MassDEP (a.k.a. the "WPP" file).
   #' 3. `core_<site>_<year>` - just the good stuff. This is the file used for producing summaries and reports.
   #'
   #' An additional file is written for internal use by `check_site`:
   #' 1. `hash.txt` - a tab-delimited file lists paths to deployment files and md5 hashes.
   #'
   #' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`). The path must include QCed results
   #' @param max_gap Maximum gap to quietly accept between deployments (hours); a msg will be printed if this gap is exceeded
   #' @param report Run `report_site` if TRUE
   #' @importFrom lubridate interval dminutes date duration dhours year yday
   #' @import utils
   #' @export



   paths <- lookup_site_paths(site_dir, warn = TRUE)
   if(dim(paths$deployments)[1] == 0)
      stop(paste0('There are no valid deployments (both QC and Metadata files) for ', site_dir))

   qc <- lapply(paths$deployments$QCpath, FUN = 'read.csv')                            # Read QC file for each deployment

   all_cols <- get_expected_columns('final_all')                                       # get canonical columns in the right order
   wpp_cols <- get_expected_columns('final_WPP')                                       # can change cols for WPP if wanted; at the moment, it's all columns
   core_cols <- get_expected_columns('final_core')
   sensor_cols <- get_expected_columns('final_sensors')                                # these are the columns that'll get "DR" for rejected data in WPP result file
   qc_codes <- read.csv(system.file('extdata/QC_codes.csv', package = 'BuzzardsBay'))  # read QC rejection codes (see inst/extdata/README_QC_codes.md)
   if(!all(c('QC_Code', 'Rejection') %in% names(qc_codes)))
      stop('Something is wrong with qc_codes.csv')


   t <- basename(paths$deployments$QCpath)                                             # pull deployment names out of paths
   deployments <- sub('\\.csv$', '', tolower(substring(t, regexpr('\\d{4}-\\d{2}-\\d{2}', t))))

   for(i in 1:length(qc)) {                                                            # clean up data: for each deployment,
      qc[[i]][, all_cols[!all_cols %in% names(qc[[i]])]] <- NA                         #    add missing required columns
      qc[[i]] <- qc[[i]][, all_cols]                                                   #    get the columns we want in canonical order and drop the junk

      qc[[i]]$Date_Time <- format_csv_date_time(qc[[i]]$Date_Time, format = 'character')#    reformat dates and dates/times that may have been damaged by Excel
      qc[[i]]$Date <- substring(qc[[i]]$Date_Time, regexpr('\\d{4}-\\d{2}-\\d{2}', qc[[i]]$Date_Time), 10)
   }

   site <- qc[[1]]$Site[1]
   z <- qc[[1]]

   if(length(qc) > 1)                                                                  # if we have more than one deployment in season,
      for(i in 1:(length(qc) - 1)) {                                                   #    Fill gaps: for each pair of deployments,
         x <- c(tail(qc[[i]]$Date_Time, 1), head(qc[[i + 1]]$Date_Time, 1))            #       date of tail of first deployment in pair, head of second one
         x <- as.POSIXct(x)                                                            #       dates to POSIX
         gap <- interval(x[1], x[2]) / dminutes(1)                                     #       gap to fill, in minutes
         m <- yaml::read_yaml(paths$deployments$mdpath[i])$logging_interval_min        #       logging interval of first deployment in pair (min)
         need <- ceiling(gap / m) - 1                                                  #       how many dates do we need to interpolate?
         fill <- x[1] + dminutes(1:need * m)                                           #       here are our interpolated times
         fill <- format(fill, format = '%Y-%m-%d %H:%M:%S')                            #       formatted in the final form

         y <- data.frame(matrix(NA, length(fill), length(all_cols)))                   #       create data frame to fill the gap, with Site, Date, and Date_Time, all others NA
         names(y) <- all_cols
         y$Site <- site
         y$Date <- format(date(fill), format = '%Y-%m-%d')
         y$Date_Time <- fill
         y$Time <- sub('\\d{4}-\\d{2}-\\d{2} ', '', fill)

         z <- rbind(z, y, qc[[i + 1]])                                                 #       build up result: what we've already got, gap fill, and second deployment of pair

         if((d <- duration(gap, units = 'minute')) > dhours(max_gap))                  #       warn if there's a large gap between deployments
            msg('Note: gap between deployments ', deployments[i], ' and ', deployments[i + 1], ' is ', format(d))
      }


   #Add additional columns and put everything in the right order

   # f <- lookup_paths(dirname(dirname(site_dir)), year)$sites
   f <- paths$sites

   if(!file.exists(f))
      stop('sites.csv is missing')
   x <- read.csv(f)                                                                    # insert site-level columns from sites.csv
   if(!site %in% x$site)                                                               # being careful
      stop(paste0('Site ', site, ' is not in sites.csv'))

   z$Waterbody <- x$WaterBody[x$site == site]                                          # get waterbody

   if(all(is.na(z$Latitude)))                                                          # If lat/long aren't present, pull from sites file - only if all missing
      z$Latitude <- x$latitude[x$site == site]
   if(all(is.na(z$Longitude)))
      z$Longitude <- x$longitude[x$site == site]

   z$Unique_ID <- 1:dim(z)[1]                                                          # unique ID is simply row number
   z$Julian_Date <- yday(z$Date)                                                       #  Julian date, really day in year


   'element' <- function(x, l)                                                         # proper element function that does %in% as in APL
      Reduce('|', lapply(l, FUN = function(l, x) x == l, x))

   fatal <- qc_codes$QC_Code[qc_codes$Rejection == 2]                                  # check for fatal 9999s (or whatever; it's rejection code 3)
   if(any(t <- element(z[, c('Gen_QC', paste0(sensor_cols, '_QC'))], fatal), na.rm = TRUE)) {
      w <- paste(unique(z$Date[apply(t, 1, FUN = any, na.rm = TRUE)]), collapse = ', ')
      s <- sum(t, na.rm = TRUE)
      p <- ifelse(s > 1, 's ', ' ')
      fatal2 <- paste(fatal, collapse = ', ')
      stop(paste0('QC code', ifelse(length(fatal) > 1, 's ', ' '), fatal2, ' found in ', s, ' place', p, 'on date', p, w, '. Review and edit the deployments before rerunning.'))
   }


   # write three versions of data file

   year <- year(z$Date[1])

   rpath <- 'combined'
   if(!dir.exists(f <- file.path(site_dir, rpath)))                                    # create result combined/ directory
      dir.create(f)

   res <- NULL
   res[1] <- file.path(rpath, paste0('archive_', site, '_', year, '.csv'))
   write.csv(z, file = file.path(site_dir, res[1]), row.names = FALSE,
             quote = FALSE, na = '#N/A')                                               # "archive" result file, with all columns and all data, including rejected values


   # now replace rejected values
   r <- qc_codes$Rejection[match(z$Gen_QC, qc_codes$QC_Code)]                          # Gen_QC has rejection code for entire row
   z[as.logical(r), sensor_cols] <- 'DR'

   failure <- FALSE
   for(sensor in sensor_cols) {                                                        # For each sensor column,
      r <- qc_codes$Rejection[match(z[, paste0(sensor, '_QC')], qc_codes$QC_Code)]     #    reject sensor metrics based on individual sensor QC columns
      if(any(is.na(r))) {
         msg('*** Invalid QC code for ', sensor, ' on ', paste0(z$Date[is.na(r)], collapse = ', '))
         failure <- TRUE
      }
      r[is.na(r)] <- 0
      z[as.logical(r), sensor] <- 'DR'
   }

   if(failure)
      stop('Invalid QC codes')

   res[2] <- file.path(rpath, paste0('WPP_', site, '_', year, '.csv'))
   write.csv(z[, wpp_cols], file = file.path(site_dir, res[2]), row.names = FALSE,
             quote = FALSE, na = '#N/A')                                                # "WPP" result file, with all columns; rejected values replaced with "DR"

   z[z == 'DR'] <- NA
   res[3] <- file.path(rpath, paste0('core_', site, '_', year, '.csv'))
   write.csv(z[, core_cols], file = file.path(site_dir, res[3]), row.names = FALSE,
             quote = FALSE, na = '')                                                   # "core" result file, with selected columns; rejected values replaced with blank


   x <- paths$deployments$QCpath
   x <- substring(x, regexpr('\\d{4}-\\d{2}-\\d{2}', x))                               # pull relative paths for QC files
   hash <- data.frame(file = x, type = 'source', hash = paths$deployments$hash)        # write hashes
   hash <- rbind(hash, data.frame(file = res, type = 'result', hash = get_file_hashes(file.path(site_dir, res))))
   write.table(hash, file = file.path(site_dir, rpath, 'hash.txt'), sep = '\t', row.names = FALSE, quote = FALSE)

   msg('\nSite ', site, ' processed for ', year, '. There were ', length(qc), ' deployments and a total of ', format(dim(z)[1], big.mark = ','), ' rows.')
   msg('Results are in ', site_dir, '/')

   if(report) {
      msg('')
      report_site(site_dir, check = FALSE)
   }
}
