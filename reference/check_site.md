# Check to be sure that result files from `stitch_site` are up to date

Check that source files for a site and year haven't changed since
[stitch_site](https://umasscds.github.io/BuzzardsBay/reference/stitch_site.md)
was used to create result files. Uses `hash.txt`, created by
`check_site`. Separately reports on missing hash file, missing source or
result files, and changed source or result files.

## Usage

``` r
check_site(site_dir, check_report = TRUE, check_baywatchers = TRUE)
```

## Arguments

- site_dir:

  Full path to site data (i.e., `<base>/<year>/<site>`). The path must
  include QC'd results and result files from
  [stitch_site](https://umasscds.github.io/BuzzardsBay/reference/stitch_site.md).

- check_report:

  If TRUE, check to see if the report is up to date. Don't check when
  calling from report_site, of course.

- check_baywatchers:

  IF TRUE, check to see if the extracted Baywatchers data are up to date
  with respect to the source Baywatchers Excel file in the base data
  directory.

## Value

Silently returns TRUE if validation was successful.

## Details

Note that check_site does not throw errors–it simply tells you what's
wrong. A calling function (currently, just report_site) can use the
silent return value to throw appropriate errors.
