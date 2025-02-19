'stitch_site' <- function(site_dir) {

  #' Stitch all deployments for a site and year
  #'
  #' Merges all QCed deployments for the specified site and year and writes result files. Missing dates and
  #' times are interpolated, with a warning for gaps that are suspiciously large. Data that are out range for
  #' their sensor are flagged. Three files are written:
  #' 1. archive.csv - contains all columns, for complete archival.
  #' 2. share.csv - contains only columns required by MassDEP (a.k.a. the "WPP" file)
  #' 3. core - just the good stuff. This is the file used for producing summaries and reports.
  #'
  #' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`). The path must include QCed results.
  #' @export



  paths <- lookup_site_paths(site_dir)
  qc <- lapply(paths$deployments$QCpath, FUN = 'read.csv')          # Read QC file for each deployment

  for(i in 2:length(qc)) {                                          # For each pair of deployments, look for gaps
    x <- rbind(tail(qc[[i - 1]], 1), head(qc[[i]], 1))

    # get logging_interval_min from YAML metadata file
  }


}
