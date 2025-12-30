# Interactive logger data plot

See the rmarkdown document included with the package for example usage,
found by running:
`system.file("rmd/QAQC_report.Rmd", package = "BuzzardsBay")`.

## Usage

``` r
bb_interactive_plot(
  d,
  dl,
  focal_column,
  jump_pattern,
  focal_flag_pattern,
  plot_label,
  focal_flag_label = plot_label,
  y_label,
  threshold_values,
  threshold_labels,
  threshold_colors,
  range_limit = c(NA, NA)
)
```

## Arguments

- d:

  Data frame with logger data as produced by
  [`qc_deployment()`](https://umasscds.github.io/BuzzardsBay/reference/qc_deployment.md)

- dl:

  Long version of the same data.

- focal_column:

  A single column from `d`

- jump_pattern:

  Regular expression to identify jump flags for the focal columns.

- focal_flag_pattern:

  Regular expression to identify all flags for the focal columns

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

- range_limit:

  The plot range will never exceed this range - it can be more
  restricted.

## Value

A plotly plot object.

## Details

`bb_interactive_plot()` uses the **plotly** package to make an
interactive plot of data from a Buzzard's Bay logger deployment.
