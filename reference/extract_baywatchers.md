# Extract relevant Baywatchers data from ginormous Excel file

Pulls the relevant site, date, and DO values from the Baywatchers source
file for a given year. Rows with `DO_QC = 9` will be dropped. Rows with
missing times (column `TIME`) will also be dropped. The results will be
written to `<year>/baywatchers.csv`, along with a hash file,
`bay_hash.txt`.

## Usage

``` r
extract_baywatchers(
  base_dir,
  year,
  file = "bbcdataCURRENT.xlsx",
  header_line = 3
)
```

## Arguments

- base_dir:

  Path to BB_Data base directory

- year:

  Year to extract data for

- file:

  File name of Baywatchers Excel file. This file must be in the base
  directory.

- header_line:

  Line in the Excel with headers

## Details

Run this before `report_site` if you want to include the two Baywatchers
plots (run with `baywatchers = TRUE`). It only needs to be run once for
each year (or if the Baywatchers data are updated). `check_site` will
check to make sure `baywatchers.csv` is up to date with respect to the
source Excel file.
