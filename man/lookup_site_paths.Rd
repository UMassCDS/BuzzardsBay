% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lookup_site_paths.R
\name{lookup_site_paths}
\alias{lookup_site_paths}
\title{Look up paths for a specified site}
\usage{
lookup_site_paths(site_dir, warn = FALSE)
}
\arguments{
\item{site_dir}{Full path to site data (i.e., \verb{<base>/<year>/<site>}); this path must include QC'd results}

\item{warn}{If TRUE, chatter on missing files and just drop them; otherwise throw an error}
}
\value{
A named list consisting of:
\item{sites}{The full path to the site info table}
\item{deployments}{A data frame with a row for each deployment, and columns \code{date}, \code{QCpath}, \code{md_path}, and \code{hash},
containing the date for each deployment, the full path to the final QC'd data, the full path to the deployment metadata
file, and the md5 hash of the QC'd data file.}
}
\description{
Find and return paths to all deployment directories, metadata files, and final QC files for selected year and site.
}
\keyword{internal}
