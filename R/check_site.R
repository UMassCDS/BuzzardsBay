'check_site' <- function(site_dir) {

  #' Check to be sure that result files from `stitch_site` are up to date
  #'
  #' Check that source files for a site and year haven't changed since `stitch_site` was used
  #' to create result files. Uses `hash.txt`, created by `check_site`.
  #'
  #' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`). The path must include
  #' QCed results and result files from `stitch_site`.
  #' @export



  if(!file.exists(f <- file.path(site_dir, 'combined/hash.txt')))
    stop(paste0('Hash file ', f, ' is missing. Most likely stitch_site hasn\'t been run for this deployment.'))

  hash <- read.table(f, sep = '\t', header = TRUE)                        # read hash table from previous run


  paths <- lookup_site_paths(site_dir, warn = TRUE)                       # and get hashes for current files
  if(dim(paths$deployments)[1] == 0)
    stop(paste0('There are no valid deployments (both QC and Metadata files) for ', site_dir))


  m <- match(basename(hash$file), basename(paths$deployments$QCpath))       # match deployment QC files
  if(any(is.na(m)))
    stop(paste0('Missing deployment files: ',
                paste0(basename(paths$deployments$QCpath)[is.na(m)], collapse = ', ')))


  ok <- paths$deployments$hash[m] == hash$hash                            # are hashes the same?
  if(all(ok))
    cat('Site ', site_dir, ' validated. Result files are up to date.\n', sep = '')
  else
    cat('*** Site ', site_dir, ' is NOT up to date. You\'ll need to
    rerun stitch_site and recreate reports for this site.\n', sep = '')
}
