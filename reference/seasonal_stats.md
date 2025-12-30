# Produce seasonal stats for a site

Produces a data frame of seasonal stats.

## Usage

``` r
seasonal_stats(core, clip = NULL)
```

## Arguments

- core:

  Core data frame, produced by `stitch_site`

- clip:

  Optionally supply a pair of dates (in `yyyy-mm-dd` format) to clip
  seasonal statistics

## Value

List of:

- `table`:

  Data frame with a column of the statistic name and a column with the
  numeric statistics

- `formatted`:

  Data frame with a column of the statistic name and a column with the
  formatted statistics
