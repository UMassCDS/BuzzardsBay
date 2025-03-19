#' Extract relevant Baywatchers data from ginormous Excel file
#'
#' Pulls the relevant site, date, and DO values from the Baywatchers source file for a
#' given year. Rows with `DO_QC = 9` will be dropped. Rows with missing times (column `TIME`)
#' will also be dropped. The results will be written to `<year>/baywatchers.csv`, along with
#' a hash file, `bay_hash.txt`.
#'
#' Run this before `report_site` if you want to include the two Baywatchers plots (run with
#' `baywatchers = TRUE`). It only needs to be run once for each year (or if the Baywatchers
#' data are updated). `check_site` will check to make sure `baywatchers.csv` is up to date
#' with respect to the source Excel file.
#'
#' @param base_dir Path to BB_Data base directory
#' @param year Year to extract data for
#' @param file File name of Baywatchers Excel file. This file must be in the base directory.
#' @param header_line Line in the Excel with headers
#' @importFrom digest digest
#' @importFrom lubridate ymd
#' @importFrom hms as_hms
#' @export


extract_baywatchers <- function(base_dir, year, file = 'bbcdataCURRENT.xlsx', header_line = 3) {


   f <- file.path(base_dir, file)                                                                              # here's the Excel file

   if(!file.exists(f))
      stop(paste0('Baywatchers Excel file ', f, ' doesn\'t exist\n   If it\'s not available,
                  you can exclude Baywatchers data from report_site with baywatchers = FALSE'))

   x <- readBin(f, 'raw', 1e9)
   hash <- data.frame(file = file, hash = digest::digest(x))                                                   # hash it

   x <- suppressWarnings(read_excel(f, sheet = 'all', skip = header_line - 1, .name_repair = 'minimal'))       # read this monster

   x <- x[x$YEAR == year, ]                                                                                    # this is the year we want
   if(dim(x)[1] == 0)
      stop('The requested year is not in the Baywatchers file')

   x <- x[is.na(x$DO_QC) | x$DO_QC != 9, ]                                                                     # drop rows with DO_QC = 9
   x <- x[, c('STN_ID', 'SAMP_DATE', 'TIME', 'DO_MGL')]                                                        # these are the columns we care about now
   x <- x[!is.na(x$TIME), ]                                                                                    # drop records with no TIME
   x$Date_Time <- as.POSIXct(paste(ymd(x$SAMP_DATE), as.character(hms::as_hms(x$TIME))))                       # build date and time
   x <- x[, c('STN_ID', 'Date_Time', 'DO_MGL')]
   names(x) <- c('Site', 'Date_Time', 'DO')
   x <- x[order(x$Site, x$Date_Time), ]

   if(!file.exists(dir <- file.path(base_dir, year)))
      dir.create(dir)
   write.csv(x, f <- file.path(dir, 'baywatchers.csv'), row.names = FALSE,
             quote = FALSE, na = '')                                                                           # save as CSV
   write.table(hash, file = file.path(dir, 'bay_hash.txt'), sep = '\t',                                         # and write hash file
               row.names = FALSE, quote = FALSE)

   msg('\nBaywatchers data processed for ', year)
   msg('Results are in ', f)

}
