# Look up paths for a specified site

Find and return paths to all deployment directories, metadata files, and
final QC files for selected year and site.

## Usage

``` r
lookup_site_paths(site_dir, warn = FALSE)
```

## Arguments

- site_dir:

  Full path to site data (i.e., `<base>/<year>/<site>`); this path must
  include QC'd results

- warn:

  If TRUE, chatter on missing files and just drop them; otherwise throw
  an error

## Value

A named list consisting of:

- sites:

  The full path to the site info table

- deployments:

  A data frame with a row for each deployment, and columns `date`,
  `QCpath`, `md_path`, and `hash`, containing the date for each
  deployment, the full path to the final QC'd data, the full path to the
  deployment metadata file, and the md5 hash of the QC'd data file.
