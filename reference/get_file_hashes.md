# Get md5 hashes for a vector of files

Given one or more file paths and names, return md5 hashes for each.
Returns NA for files that don't exist.

## Usage

``` r
get_file_hashes(files)
```

## Arguments

- files:

  A list of full file specifications

## Value

A matching vector of md5 hashes
