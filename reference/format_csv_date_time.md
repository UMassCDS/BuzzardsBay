# Format CSV date time that might have been corrupted by excel

Excel with US localization will automatically convert dates from
year-month-day to month/day/year. Thus whenever a date is read from a
CSV that might have been edited with Excel I'm going to check for
slashes and assume month/day/year if they are present.

## Usage

``` r
format_csv_date_time(x, format = "datetime")
```

## Arguments

- x:

  Date times as character month/day/year h:m or year-month-day h:m can
  be mixed in one vector. h:m:s is also acceptable in place of h:m Note
  if the time is missing it will be interpreted as midnight (00:00:00)
  thus month/day/year and year-month-day without times are also
  acceptable.

- format:

  Either `"datetime"` to return a datetime object or "`character`" to
  return as characters standardized on year-month-day h:m:s.

## Value

Dates times as year-month-day h:m:s (character) or POSIXct depending on
the `format`.

## Details

A separate issue - sometimes date-times are missing the time at midnight
thus instead of "2025-05-28 00:00:00" it might be read as "2025-05-28".

## Examples

``` r
# example code
if (FALSE) { # \dontrun{
x <- c(NA, "2024-05-15 11:50:00", "2024-05-16", "5/17/2024 00:10")
format_csv_date_time(x)
} # }
```
