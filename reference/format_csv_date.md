# Format CSV date that might have been corrupted by excel

Excel with US localization will automatically convert dates from
year-month-day to month/day/year. Thus whenever a date is read from a
CSV that might have been edited with Excel I'm going to check for
slashes and assume month/day/year if they are present.

## Usage

``` r
format_csv_date(x)
```

## Arguments

- x:

  Dates as character month/day/year or year-month-day can be mixed in
  one vector.

## Value

Dates as year-month-day (character)

## Examples

``` r
# example code
if (FALSE) { # \dontrun{
x <- c(NA, "2024-05-15", "2024-05-16", "5/16/2024")
} # }
```
