#' Get the full site name for a site
#'
#' Pulls the full site name from the sites table.
#'
#' @param site_dir Site directory
#' @return Full name of the site
#' @keywords internal


get_site_name <- function(site_dir) {


   site <- toupper(basename(site_dir))
   paths <- lookup_site_paths(site_dir, warn = TRUE)

   f <- paths$sites
   if(!file.exists(f))
      stop('sites.csv is missing')
   x <- read.csv(f)
   if(!site %in% x$site)
      stop('Site ', site, ' does not exist in the sites table')
   z <- x$description[x$site == site]

   z
}
