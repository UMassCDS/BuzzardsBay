# Extract specific metadata items from the MX801 details sheet

This it a internal helper function to extract MX801 details (metadata)
from the third sheet of an Excel file.

## Usage

``` r
parse_mx801_details(file)
```

## Arguments

- file:

  The path to the calibrated Excel (`.xlsx`) file from the MX801 logger

## Value

A nested list with selected metadata from the details

## Details

`parse_mx801_details()` is kludgy because the data is written into the
details file in a fairly haphazard way.

The approach is to do a bunch of formatting of the text from the details
file to make it somewhat YAML like, to parse as YAML, and then to do a
little more cleanup and extraction.

- [description of the output metadata
  fields](https://docs.google.com/document/d/1GKw3eq9ALigEcX_AWl4vnlejSzsTiIVHzy6LoKCR1jw).

## Examples

``` r
# parse_mx801_details() is an internal function so example code will
# only work after devtools::load_all()
if (FALSE) { # \dontrun{

p <- setup_example_dir(site_filter = "BBC", year_filter = 2025,
 deployment_filter = "2025-01-04")
f <- list.files(file.path(p$deployment, "Calibrated"),
                pattern =  ".xlsx$", full.names  = TRUE )
md <- parse_mx801_details(f)
yaml::as.yaml(md) |> cat(sep = "\n")
} # }
```
