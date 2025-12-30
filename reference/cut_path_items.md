# cut items off the end of a path

cut items off the end of a path

## Usage

``` r
cut_path_items(x, ncut)
```

## Arguments

- x:

  A path

- ncut:

  The number of items to cut

## Value

A shortened path

## Examples

``` r
if (FALSE) { # \dontrun{
  deployment_dir <- "C:/temp/bb_demo//BB_Data/2023/RB1/2023-06-09"
  base_dir <- cut_path_items(deployment_dir, 3)
} # }
```
