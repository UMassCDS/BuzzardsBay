# Get the tide height at a particular station corresponding to a series of date, times. Note due to limitations in the **rtide** package this only works for about a third of the Buzzards Bay NOAA tide stations.

`get_tide_height()` is a wrapper to
[`rtide::tide_height()`](https://rdrr.io/pkg/rtide/man/tide_height.html)
that works with a date time vector and also checks the station against
`tide_station_info`.

## Usage

``` r
get_tide_height(dt, station)
```

## Arguments

- dt:

  Series of date-time values as POSIXct. The timezone must be properly
  set.

- station:

  A station name or station ID as it appears in
  [tide_station_info](https://umasscds.github.io/BuzzardsBay/reference/tide_station_info.md).

## Value

A series of tide heights corresponding to the date-times in `dt` Heights
are in meters and, I think, are relative to
[MLLW](https://tidesandcurrents.noaa.gov/datum_options.html#MLLW) (Mean
Lower Low Water). Although, I could only find this stated about
individual stations and not for all stations in general.

See for example the datum information for [PENIKESE ISLAND
MA](https://tidesandcurrents.noaa.gov/datums.html?id=8448248), which
states "NOTICE: All data values are relative to the MLLW.".
