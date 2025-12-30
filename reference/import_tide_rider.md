# Import Tide Rider Data

This imports the location information for a Tide Rider from a CSV file.
See
[`import_calibrated_data()`](https://umasscds.github.io/BuzzardsBay/reference/import_calibrated_data.md)
for more information.

## Usage

``` r
import_tide_rider(paths)
```

## Arguments

- paths:

  paths list as returned from
  [`lookup_paths()`](https://umasscds.github.io/BuzzardsBay/reference/lookup_paths.md)
  the only component used here is `$deployment_cal_dir`. It should
  contain a csv file with `"TR"` bounded by `"_"` or `"."` e.g. `"_TR_"`
  or `"_TR."`.

## Value

Tide Rider data with columns:

- Date_Time:

  Date and time of each record as character in the format year-month-day
  h:m:s (all numeric). The file can use that format or day-month-year
  h:m:s where month is an abbreviated month name e.g. "12-Aug-2025
  13:40:00".

- Latitude, Longitude:

  Location in spherical coordinates. Assumed to be WGS84 (EPSG:4326)

- Depth:

  Logger depth in meters

- TR_Flags:

  Tide Rider Flags.
