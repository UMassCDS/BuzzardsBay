#' Check to be sure that result files from `stitch_site` are up to date
#'
#' Check that source files for a site and year haven't changed since `stitch_site` was used
#' to create result files. Uses `hash.txt`, created by `check_site`. Separately reports on
#' missing hash file, missing source or result files, and changed source or result files.
#'
#' Note that check_site does not throw errors--it simply tells you what's wrong. A calling
#' function (currently, just report_site) can use the silent return value to throw appropriate errors.
#'
#' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`). The path must include
#' QC'd results and result files from `stitch_site`.
#' @param check_report If TRUE, check to see if the report is up to date. Don't check when calling from
#' report_site, of course.
#' @param check_baywatchers IF TRUE, check to see if the extracted Baywatchers data are up to date with
#' respect to the source Baywatchers Excel file in the base data directory.
#' @return Silently returns TRUE if validation was successful.
#' @export


check_site <- function(site_dir, check_report = TRUE, check_baywatchers = TRUE) {


   if(!file.exists(f <- file.path(site_dir, 'combined/hash.txt'))) {
      msg('*** Hash file ', f, ' is missing.\nMost likely either your path is wrong or stitch_site hasn\'t been run for this deployment.')
      ok <- FALSE
   }
   else {
      hash <- read.table(f, sep = '\t', header = TRUE)                           # read hash table from previous run
      newhash <- get_file_hashes(file.path(site_dir, hash$file))                 # and rehash these files

      missing <- is.na(newhash)                                                  # missing files
      changed <- (hash$hash != newhash) & !missing                               # changed files

      ok <- !any(changed | missing)                                              # are we good?

      if(!ok)
         msg('*** Errors validating site ', site_dir)

      if(any(missing & hash$type == 'source'))
         msg('Source files used in the previous run have apparently been deleted. If this was intentional, rerun stitch_site.')

      if(any(changed & hash$type == 'source'))
         msg('Source files have changed since stitch_site was run. Rerun stitch_site to update.')

      if(any(missing & hash$type == 'result'))
         msg('Result files are missing. Rerun stitch_site to recreate them.')

      if(any(changed & hash$type == 'result'))
         msg('Result files have been changed since stitch_site was run. Rerun stitch_site to replace them.')


      if(ok)
         msg('Site ', site_dir, ' validated. Result files are up to date.')
      else {
         msg('')
         print(data.frame(file = hash$file, status = ifelse(missing, 'missing', ifelse(changed, 'changed', 'ok'))))
      }
   }

   if(ok & check_report)                                                         # if result files are good and we're checking the report,
      if(file.exists(f <- file.path(site_dir, 'combined/report_hash.txt'))) {    #    if report_hash exists,
         x <- get_file_hashes(file.path(site_dir, 'combined/hash.txt'))
         if(x == readLines(f))                                                   #       check to see if it's outdated (but don't throw ok = FALSE if it isn't)
            msg('Report for ', site_dir, ' is up to date.')
         else
            msg('*** Report for ', site_dir, ' is outdated. Run report_site again to create a fresh report and daily stats.')
      }

   if(check_baywatchers) {
      if(!file.exists(file.path(dirname(site_dir), 'baywatchers.csv'))) {        #    if baywatchers.csv doesn't exist,
         msg('*** Baywatchers data haven\'t been extracted yet. Run extract_baywatchers if you want reports')
         msg('    that include Baywatchers plots, or use report_site(..., baywatchers = FALSE) to skip them.')
         ok <- FALSE
      }
      else {
         if(!file.exists(f <- file.path(dirname(site_dir), 'bay_hash.txt')))        #    if bay_hash doesn't exist,
            msg('*** Baywatchers data have been extracted, but the bay_hash.txt was deleted, so it\'s not
              possible to check whether it\'s up to date. Proceed with caution.')
         else {
            x <- read.table(f, sep = '\t', header = TRUE)
            g <- file.path(dirname(dirname(site_dir)), x$file)
            if(!file.exists(g))
               msg('*** Extracted Baywatchers data are present, but source Excel file is not. Proceed with caution.')
            else {
               y <- readBin(g, 'raw', 1e9)
               if(x$hash == digest::digest(y))                                      #       check to see if it's outdated (but don't throw ok = FALSE if it isn't)
                  msg('Baywatchers file for ', basename(dirname(site_dir)), ' is up to date.')
               else {
                  msg('*** Baywatchers file for ', basename(dirname(site_dir)),' is outdated. Run extract_baywatchers again to get updated')
                  msg('    Baywatchers data, or use report_site(..., baywatchers = FALSE) to skip them.')
                  ok <- FALSE
               }
            }
         }
      }
   }


   invisible(ok)
}
