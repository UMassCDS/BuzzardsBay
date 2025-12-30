# Clean up column names for basic CSV input

`clean_csv_import_names()` is an internal function to resolve variable
input names into their canonical form. It should work with input columns
names from the MX801 logger; from the U24 and U26 loggers; and using the
canonical names: "Date_Time", "Raw_DO", "Temp_DOLog", "DO",
"DO_Pct_Sat", "High_Range", "Temp_CondLog", "Spec_Cond", "Salinity",
"Depth", "Latitude", and "Longitude". The last three names are optional.

## Usage

``` r
clean_csv_import_names(d)
```

## Arguments

- d:

  A data frame with possibly non-standard names.

## Value

A data frame with updated names. Columns are not dropped or re-ordered.

## Details

When combining names from the U24 and U26 loggers for use with this
function the two temperature columns will have to be manually renamed to
"Temp_CondLog", and "Temp_DOLog".
