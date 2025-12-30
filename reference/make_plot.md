# Produce a time series plot for the final report

Produce a time series plot for the final report. Values are plotted as
small points, with specified data, x and y columns, and axis labels. A
horizontal line can optionally be plotted.

## Usage

``` r
make_plot(
  core = core,
  x = core$Date_Time,
  y,
  x_lab,
  y_lab,
  hline = 0,
  diag = FALSE,
  point_size = 0.25,
  linetype = 0,
  vline = NULL
)
```

## Arguments

- core:

  Core data frame, produced by `stitch_site`

- x:

  X variable, typically Date_Time

- y:

  Y variable

- x_lab:

  Label for x-axis

- y_lab:

  Label for y-axis

- hline:

  Optional horizontal line at specified value on the y-axis

- diag:

  If TRUE, set x and y axes to the same range and draw a diagonal with a
  slope of 1

- point_size:

  Optional size of points in plot

- linetype:

  Optional line type (default 0, is no line)

## Value

A ggplot2 object
