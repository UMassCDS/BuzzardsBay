#' Look up paths for a specified site
#'
#' Find and return paths to all depolyment directories, metadata files, and final QC files for selected year and site.
#'
#' @param site_dir Full path to site data (i.e., `<base>/<year>/<site>`); this path must include QCed results
#' @param warn If TRUE, chatter on missing files and just drop them; otherwise throw an error
#' @return A named list consisting of:
#' \item{sites}{The full path to the site info table}
#' \item{deployments}{A data frame with a row for each deployment, and columns `date`, `QCpath`, `md_path`, and `hash`,
#' containing the date for each deployment, the full path to the final QCed data, the full path to the deployment metadata
#' file, and the md5 hash of the QCed data file.}
#' @keywords internal


lookup_site_paths <- function(site_dir, warn = FALSE) {


   if(!file.exists(site_dir))
      stop('Path ', site_dir, ' does not exist')

   dir <- list.files(site_dir)                                             # top-level directory for site

   s <- lookup_paths(dirname(dirname(site_dir)),
                     basename(dirname(site_dir)))$sites
   z <- list(sites = s)                                                    # result$sites
   if(!file.exists(z$sites))
      stop(paste0('The sites metadata file is missing for ', site_dir))

   site <- toupper(basename(site_dir))                                     # pull 3 letter site code out of path

   deploy <- list.files(site_dir)                                          # deployment folders
   deploy <- deploy[grep('^\\d{4}-\\d{2}-\\d{2}$', deploy)]                # make sure we don't pick up anything but yyyy-mm-dd

   qc <- sort(file.path(site_dir, deploy, paste0('QC_', site, '_', deploy, '.csv')))
   md <- sort(file.path(site_dir, deploy, paste0('Metadata_', site, '_', deploy, '.yml')))
   z$deployments <- data.frame(date = deploy, QCpath = qc, mdpath = md)
   # z$deployments <- z$deployments[file.exists(z$deploymentsQCpath)]        # drop deployments with no QC file

   t <- !cbind(file.exists(z$deployments$QCpath),
               file.exists(z$deployments$mdpath))                          # check for missing files
   if(any(t)) {
      m <- paste0('Missing deployment files: ', paste0(basename(c(z$deployments$QCpath[t[, 1]], z$deployments$mdpath[t[, 2]])), collapse = ', '))
      if(warn) {                                                           # if warn,
         z$deployments <- z$deployments[!t[, 1] | !t[, 2], ]               #    drop offending rows and whine
         msg('Note: ', m)
      }
      else                                                                 # else, throw an error
         stop(m)
   }

   z$deployments$hash <- get_file_hashes(z$deployments$QCpath)             # get hashes of QC files
   z
}
