# Combine the flags from individual "\_Flags" columns into a single flags vector.

This is a internal function called several times from
[`qc_deployment()`](https://umasscds.github.io/BuzzardsBay/reference/qc_deployment.md)

## Usage

``` r
combine_flags(d)
```

## Arguments

- d:

  A data frame. Columns with "flag" in the name (ignoring case) with the
  exception of a column called "Flags" (case specific) will be
  concatenated into a return vector.

## Value

a vector of the combined flags
