# Create a BuzzardsBay parameter file

The parameter file is used to set parameters that affect how flags are
calculated. See
[`bb_options()`](https://umasscds.github.io/BuzzardsBay/reference/bb_options.md)
for parameter descriptions.

## Usage

``` r
create_parameter_file(dir, overwrite = FALSE)
```

## Arguments

- dir:

  The path to a directory to write the file to generally either the base
  directory for the data or a site directory.

- overwrite:

  if `TRUE` overwrite any existing file.

## Value

Nothing is returned. A file is written to disk
