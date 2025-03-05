'check_site' <- function(site_dir) {

  #' Check to be sure that result files from `stitch_site` are up to date
  #'
  #' Check that source files for a site and year haven't changed since `stitch_site` was used
  #' to create result files. Uses `hash.txt`, created by `check_site`. Separately reports on
  #' missing hash file, missing source or result files, and changed source or result files.
  #'
  #' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`). The path must include
  #' QCed results and result files from `stitch_site`.
  #' @return Silently returns TRUE if validation was successful.
  #' @export



  if(!file.exists(f <- file.path(site_dir, 'combined/hash.txt'))) {
    cat(paste0('*** Hash file ', f, ' is missing.\nMost likely either your path is wrong or stitch_site hasn\'t been run for this deployment.\n'))
    ok <- FALSE
  }
  else {
    hash <- read.table(f, sep = '\t', header = TRUE)                        # read hash table from previous run
    newhash <- get_file_hashes(file.path(site_dir, hash$file))              # and rehash these files

    missing <- is.na(newhash)                                               # missing files
    changed <- (hash$hash != newhash) & !missing                            # changed files

    ok <- !any(changed | missing)                                           # are we good?

    if(!ok)
      cat('*** Errors validating site ', site_dir, '\n', sep = '')

    if(any(missing & hash$type == 'source'))
      cat('Source files used in the previous run have apparently been deleted. If this was intentional, rerun stitch_site.\n')

    if(any(changed & hash$type == 'source'))
      cat('Source files have changed since stitch_site was run. Rerun stitch_site to update.\n')

    if(any(missing & hash$type == 'result'))
      cat('Result files are missing. Rerun stitch_site to recreate them.\n')

    if(any(changed & hash$type == 'result'))
      cat('Result files have been changed since stitch_site was run. Rerun stitch_site to replace them.\n')


    if(ok)
      cat('Site ', site_dir, ' validated. Result files are up to date.\n', sep = '')
    else {
      cat('\n')
      print(data.frame(file = hash$file, status = ifelse(missing, 'missing', ifelse(changed, 'changed', 'ok'))))
    }
  }

  invisible(ok)
}
