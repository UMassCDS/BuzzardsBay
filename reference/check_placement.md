# Check SN, site, deployment date, and logger type against placements table

This internal function verifies that the logger with the given SN was
placed at the expected, site, at the deployment date and that it is of
the expected type.

## Usage

``` r
check_placement(sn, type, placements, deployment_date, site)
```

## Arguments

- sn:

  The logger serial number

- type:

  The logger type: `"DO"`, or `"Cond"`

- placements:

  The placements table

- deployment_date:

  The deployment date (end of deployment window). A deployment is a
  single dip in the water ending with a data download.

- site:

  The site where the logger was deployed

## Value

An informative error is thrown if something is wrong. Nothing is
returned.
