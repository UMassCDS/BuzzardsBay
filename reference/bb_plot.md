# Make static plot of logger data

`bb_plot()` uses **gplot2** to generate plots of logger data. It is
primarily intended for use in reports. See the rmarkdown document
included with the package for example usage, found by running:
`system.file("rmd/QAQC_report.Rmd", package = "BuzzardsBay")`.

## Usage

``` r
bb_plot(
  d,
  dl,
  focal_columns,
  jump_pattern,
  focal_flag_pattern,
  err_pattern,
  plot_label,
  focal_flag_label = plot_label,
  y_label,
  threshold_values,
  threshold_labels,
  threshold_colors,
  lat = NULL,
  lon = NULL,
  range_limit = c(NA, NA)
)
```

## Arguments

- d:

  Data frame with logger data as produced by
  [`qc_deployment()`](https://umasscds.github.io/BuzzardsBay/reference/qc_deployment.md)

- dl:

  Long version of the same data.

- focal_columns:

  Names of columns in `d` that should be plotted, max of 2 and they
  should have comparable scales.

- jump_pattern:

  Regular expression to identify jump flags for the focal columns.

- focal_flag_pattern:

  Regular expression to identify all flags for the focal columns

- err_pattern:

  Regular expression to identify flags that indicate a sensor error code
  (typically value of -888.88) these values will be excluded when
  setting the y axis range.

- plot_label:

  Label for the plot.

- focal_flag_label:

  Label for the focal flag, " Flag" will be appended.

- y_label:

  Y axis label.

- threshold_values:

  One or more threshold values to be plotted as horizontal lines.

- threshold_labels:

  The labels (text) to use for the threshold lines, one per
  `threshold_value`.

- threshold_colors:

  The color to use for the threshold lines, can be one color or a color
  for each `threshold_value`.

- lat, lon:

  The latitude and longitude of the site, used to calculate sunrise and
  sunset times.

- range_limit:

  The plot range will never exceed this range - it can be more
  restricted.

## Value

A ggplot plot object. Use [`print()`](https://rdrr.io/r/base/print.html)
to turn it into a plot/
