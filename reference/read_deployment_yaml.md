# Read deployment metadata from a YAML file

This is used by import types 0 (CSV) and 2 (MX801 excel file) to read an
accompanying YAML file and format into standard metadata list

## Usage

``` r
read_deployment_yaml(file, mx801 = FALSE)
```

## Arguments

- file:

  The YAML file path

- mx801:

  Set to TRUE when importing for MX801 which has slightly different
  requirements

## Value

Standardized metadata list
