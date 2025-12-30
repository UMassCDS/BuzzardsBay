# Plot tide height and daylight hours

`plot_tide_sun()` Creates a plot with vertical background stripes
indicating daylight hours and a line indicating tide height. Due to a
limitation in **rtide** it doesn't work with most of the Buzzards Bay
tide stations.

## Usage

``` r
plot_tide_sun(d, station, lat, lon, tz)
```

## Arguments

- d:

  A data frame containing the DO and other data for which a companion
  Daylight and Tide height plot is needed. Only the column `Date_Time`
  is used BUT it is assumed that the interval between observations is
  consistent in the file.

- station:

  The tide station name for which the plot should be made

- lat, lon:

  The latitude and longitude of the site - used for daylight hour
  calculations.

- tz:

  The HOBOware style "timezone" associated with the `Date_Time` column
  e.g. "GMT-4:00". Note, in general in the BuzzardsBay package Date Time
  objects are stored as a string "2024-05-31 6:00:00" or converted to a
  POSIX object WITHOUT a defined timezone. The "Timezone" as used by
  HOBOware is saved in the metadata object and is an offset from GMT/UTC
  and NOT a TRUE timezone. Passing this offset as `tz` allows the local
  date times to to be converted to their UTC equivalent and the UTC
  timezone to be set such that they represent an accurate time +
  timezone for use with tide chart and daylight hour lookup.
