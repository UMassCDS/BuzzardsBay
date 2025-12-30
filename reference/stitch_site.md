# Stitch all deployments for a site and year

Merges all QC'd deployments for the specified site and year and writes
result files. Missing dates and times are interpolated, with a warning
for gaps that are suspiciously large. Data that are out range for their
sensor are flagged. Writes three versions of the data file for the
complete season, and hash files for use by
[check_site](https://umasscds.github.io/BuzzardsBay/reference/check_site.md).

## Usage

``` r
stitch_site(site_dir, max_gap = 1, report = FALSE, baywatchers = TRUE)
```

## Arguments

- site_dir:

  Full path to site data (i.e., `<base>/<year>/<site>`). The path must
  include QC'd results

- max_gap:

  Maximum gap to quietly accept between deployments (hours); a message
  will be printed if this gap is exceeded

- report:

  Run `report_site` if TRUE

- baywatchers:

  If TRUE, do 2 additional comparison plots with Baywatchers data (only
  if report = TRUE; see `report_site`)

## Details

Three versions of the data file are written to `<site_dir>/combined/`:

1.  `archive_<site>_<year>.csv` - contains all columns, for complete
    archival.

2.  `WPP_<site>_<year>.csv` - contains only columns required by MassDEP
    (a.k.a. the "WPP" file).

3.  `core_<site>_<year>` - just the good stuff. This is the file used
    for producing summaries and reports.

An additional file is written for internal use by
[check_site](https://umasscds.github.io/BuzzardsBay/reference/check_site.md):

1.  `hash.txt` - a tab-delimited file lists paths to deployment files
    and md5 hashes.
