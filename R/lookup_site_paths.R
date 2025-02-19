'lookup_site_paths' <- function(site_dir) {

  #' Look up paths for a specified site
  #'
  #' Find and return paths to all depolyment directories, metadata files, and final QC files for selected site.
  #'
  #' @param site_dir Full path to site data. The path must include QCed results.
  #' @return A named list consisting of:
  #' \item{sites}{The path to the site info table}
  #' \item{deployments}{A data frame with a row for each deployment, and columns `year`, `date`, `QCpath`, `md_path`, and `hash`,
  #' containing the year and full date for each deployment, the path to the final QCed data, the path to the deployment metadata
  #' file, and the md5 hash of the QCed data file.}
  #' @export



  dir <- list.files(site_dir)                                             # top-level directory for site
  years <- dir[grep('^\\d{4}$', dir)]                                     # find year directories
  if(length(years) == 0)
    stop(paste0('There are no year subfolders in ', site_dir))

  z <- list(sites = file.path(site_dir, years[1], 'Metadata/sites.csv'))  # result$sites
  if(!file.exists(z$sites))
    stop(paste0('The site metadata file is missing for ', site_dir))

  site <- toupper(basename(dirname(site_dir)))                            # pull 3 letter site code out of path

  for(i in 1:length(years)) {                                             # for each year,
    dir3 <- file.path(site_dir, years[i], site)                           #    third-level directory, containing deployment folders
    deploy <- list.files(dir3)
    qc <- file.path(dir3, list.files(dir3), paste0('QC_', site, '_', deploy, '.csv'))
    meta <- file.path(dir3, list.files(dir3), paste0('Metadata_', site, '_', deploy, '.yml'))

    if(i == 1)
      z$deployments <- data.frame(year = years[i], date = deploy, QCpath = qc, mdpath = meta)
    else
      z$deployments <- rbind(z$deployments, cbind(year = years[i], date = deploy, QCpath = qc, mdpath = meta))
  }

  if(any(t <- !file.exists(f <- unlist(z$deployments[, c('QCpath', 'mdpath')]))))
    stop(paste0('Missing deployment files: ', f[t], collapse = ', '))

  for(i in 1:dim(z$deployments)[1]) {                                     # now get hashes of QC files. For each file,
    x <- readr::read_file(z$deployments$QCpath[i])
    z$deployments$hash[i] <- digest::digest(x, algo = 'md5')
  }

  z
}
