# Update Buzzards Bay parameters

Internal function to update the BuzzardsBay package parameters. It sets
parameters based on the default parameters for the package, a required
global parameter file (`paths$global_parameters`) and an optional site
specific parameter file (`paths$site_parameters`).

## Usage

``` r
update_bb_parameters(paths)
```

## Arguments

- paths:

  Likely the output of
  [`lookup_paths()`](https://umasscds.github.io/BuzzardsBay/reference/lookup_paths.md)
  the only used items are `$global_parameters` and `$site_parameters.`

## Value

Nothing is returned, but package parameters are updated.

## Details

The same parameter may be set in multiple locations in which case the
precedence in decreasing order is site parameter file, global parameter
file, and package default value `default_bbp`. The currently set
parameters are stored in the `bbp` environment within the package.

Note, not all parameters need to be set in all locations. It is
recommended to set all the parameters in the global file and then only
ones that need to be changed in the site specific file.

See
[`create_parameter_file()`](https://umasscds.github.io/BuzzardsBay/reference/create_parameter_file.md)
to create a file with default values.
