# Produce a time series plot with two datasets for the final report

Produce a time series plot for the final report that includes 2 sets of
variables. Values in first set are plotted as small black points, and
those in second set as larger red points, plotted on top of the first.

## Usage

``` r
make_plot_2var(data1, data2, x1, y1, x2, y2, x_lab, y_lab)
```

## Arguments

- data1:

  Second dataset

- x1:

  Second X variable

- y1:

  Second Y variable

- x_lab:

  Label for x-axis

- y_lab:

  Label for y-axis

## Value

A ggplot2 object
