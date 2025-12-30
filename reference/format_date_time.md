# Internal function to reformat the date time date from Details.txt

Internal function to reformat the date time date from Details.txt

## Usage

``` r
format_date_time(x)
```

## Arguments

- x:

  Date time in a month/day/year h:m:s GMT-offset format

  Note this returns a string not a date time object, and the GMT offset
  is dropped. If this string is processed into a date time object the
  timezone will likely be wrong if not explicitly set.

## Value

String with year-month-day h:m:s format.

## Examples

``` r
if (FALSE) { # \dontrun{
x <- "06/10/19 08:05:37  GMT-04:00"
format_date_time(x)
} # }
```
