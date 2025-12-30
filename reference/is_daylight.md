# Determine if observation correspond to daylight hours or not

Determine if observation correspond to daylight hours or not

## Usage

``` r
is_daylight(dt, lat, lon, tz)
```

## Arguments

- dt:

  A vector of date times either as text or date time objects

- lat, lon:

  The latitude and longitude of the associated site.

- tz:

  The HOBOware style GMT offset used to define the "timezone" of the
  dates in `dt`. Probably always "GMT-4:00" but use the value saved to
  the metadata file.

## Value

A date time object with the dates in `dt` converted to UTC and with that
timezone correctly set in the object.
