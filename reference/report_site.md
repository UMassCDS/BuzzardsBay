# Produce stats and a report for a site and year

Produces daily stats and a report with seasonal stats and a number of
graphs for a specified site and year.

## Usage

``` r
report_site(
  site_dir,
  check = TRUE,
  baywatchers = TRUE,
  salinity = TRUE,
  clip = NULL
)
```

## Arguments

- site_dir:

  Full path to site data (i.e., `<base>/<year>/<site>`)

- check:

  If TRUE, runs
  [check_site](https://umasscds.github.io/BuzzardsBay/reference/check_site.md)
  to make sure source files haven't been changed

- baywatchers:

  If TRUE, do 2 additional comparison plots with Baywatchers data

- salinity:

  If TRUE, include an additional time series plot of salinity

- clip:

  Optionally supply a pair of dates (in `yyyy-mm-dd` format) to clip
  seasonal statistics

## Details

Two files are written:

1.  `daily_stats_<site>_<year>.csv` - a file with a row for each day of
    the season with several summary statistics

2.  `report_<site>_<year>.pdf` - a PDF report with a table of seasonal
    stats and a number of graphs

[stitch_site](https://umasscds.github.io/BuzzardsBay/reference/stitch_site.md)
must be run first to create the necessary data. If
[stitch_site](https://umasscds.github.io/BuzzardsBay/reference/stitch_site.md)
was run at some point in the past, it is highly advisable to run
[check_site](https://umasscds.github.io/BuzzardsBay/reference/check_site.md)
to make sure deployment files haven't changed since the last
[stitch_site](https://umasscds.github.io/BuzzardsBay/reference/stitch_site.md)
run.

Including plots based on Baywatchers data requires a file within the
site `baywatchers/<site>.csv`. This file must include the date and time
(a column that includes `Date_Time` in the name) and dissolved oxygen in
mg/L (DO in the name, but not percent, pct, or %). Column names are
case-insensitive. If this file is missing or the necessary columns are
not present, an error will be reported. You can use
`baywatchers = FALSE` for datasets that don't have Baywatchers data to
exclude these plots.

You may clip the seasonal statistics to a date range, for example,
`clip = c("2024-08-10", "2024-08-25")`. This will affect the seasonal
statistics table in the report and CSV file, but not graphs.
