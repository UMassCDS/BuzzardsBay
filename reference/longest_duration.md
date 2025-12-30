# Give duration of the longest run of low DO for each day

Finds the longest run of DO below a threshold for each day.

## Usage

``` r
longest_duration(x)
```

## Arguments

- x:

  A data frame with three columns:

  1.  `Date` The date, in format 2024-05-30

  2.  `Date_Time` The date and time, in format 2024-05-30 16:20:00

  3.  `trigger` TRUE when DO is below the selected threshold (the name
      of this column varies)

## Value

Length of the longest run of TRUEs in fractional hours

## Details

Looks into the previous day for the start of runs, as many low-DO events
start in the evening. Reported durations are no longer than 24 hours.

If trigger is all false for a day, the result is 0. If trigger is all NA
for a day, the result is NA.
