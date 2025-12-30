# Lookup the DO and conductivity logger device models

Given a deployment date and site lookup the sensors deployed there. The
assumption is that there is both a `"Do"` and `"Cond"` device type
associated with each placement and this function will throw and error if
that is violated for the specified deployment.

## Usage

``` r
lookup_devices(site, deployment_date, placements)
```

## Arguments

- site:

  The site where the logger was deployed

- deployment_date:

  The deployment date (end of deployment window). A deployment is a
  single dip in the water ending with a data download.

- placements:

  The placements table

## Value

A list with items:

- do_model,do_sn:

  Dissolved oxygen sensor model and serial number

- cond_model,cond_sn:

  Conductivity sensor model and serial number
