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
  #' QCed results and result files from `stitch_site`.
  #' @return Silently returns TRUE if validation was successful.
  #' @export


check_site <- function(site_dir) {


  if(!file.exists(f <- file.path(site_dir, 'combined/hash.txt'))) {
    msg('*** Hash file ', f, ' is missing.\nMost likely either your path is wrong or stitch_site hasn\'t been run for this deployment.')
    ok <- FALSE
  }
  else {
    hash <- read.table(f, sep = '\t', header = TRUE)                        # read hash table from previous run
    newhash <- get_file_hashes(file.path(site_dir, hash$file))              # and rehash these files

    missing <- is.na(newhash)                                               # missing files
    changed <- (hash$hash != newhash) & !missing                            # changed files

    ok <- !any(changed | missing)                                           # are we good?

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

  invisible(ok)
}
