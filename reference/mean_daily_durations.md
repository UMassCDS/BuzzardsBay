# Give mean duration of low-DO runs in hours

Returns means of runs of DO below the specified threshold in hours. Days
(noon-noon) with DO above the threshold are excluded. We use noon to
noon as most low-DO runs typically start in the evening. Multiple
day-runs are included in the means. Runs of 6 or fewer NAs surrounded by
DO below the threshold are treated as below the threshold.

## Usage

``` r
mean_daily_durations(x, threshold)
```

## Arguments

- x:

  A data frame with three columns:

  1.  `x` Data frame with Date, Date_Time, and DO

  2.  `threshold` Low-DO threshold

## Value

Mean length of low-DO runs for days with low DO, in hours
