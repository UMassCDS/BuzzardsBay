# Set up an example directory

Set up an example directory for testing and demonstrating the
**BuzzardsBay** package functions. It will be created within
`parent_dir` called `"BB_Data"` and will contain example calibrated data
files for a single deployment as well as some of project level metadata.
The files are bundled with the package and can be found in the source
within `inst/extdata/`.

## Usage

``` r
setup_example_dir(
  parent_dir = NULL,
  delete_old = FALSE,
  year_filter = NULL,
  site_filter = NULL,
  deployment_filter = NULL
)
```

## Arguments

- parent_dir:

  The directory in which to create the example files tree. If left
  `NULL` it will be set to
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html). Either way an
  error will be thrown if this a `"BB_Data"` folder already exists in
  `parent_dir` - unless `delete_old` is `TRUE`/

- delete_old:

  If `TRUE` then preexisting example data is deleted.

- year_filter:

  Optional, if specified only example data from deployments from the
  specified year will be copied over.

- site_filter:

  Optional if specified only example data from the specified site will
  be copied over.

- deployment_filter:

  Optional, if specified only example data from the given deployment
  will be copied over. Should be a deployment date e.g. `"2023-06-09`.

## Value

A named list with paths to:

- base_dir:

  The path to the newly created example base directory (`"BB_Data"`).

- deployment_dir:

  The path to the first deployment folder within `base_dir`.

- deployment_dirs:

  A vector of paths to all the example deployment directories created

## Example data sets

Below is a partial list for the full list of example datasets see
[`vignette("example-data", package = "BuzzardsBay")`](https://umasscds.github.io/BuzzardsBay/articles/example-data.md)

### 2023

- **RB1 2023-06-09** The original example data used to developing the
  package.

- **WH1X 2023-06-09, 2023-06-16, 2023-06-23** This site includes QC'd
  files; it corresponds to the included 2023 Baywatchers data from
  [`extract_baywatchers()`](https://umasscds.github.io/BuzzardsBay/reference/extract_baywatchers.md),
  which is required for two of the figures in the seasonal report.

### 2024

These were generally added to resolve errors that came up.

- **OB9** The first 2024 data set. Added to document changes from 2023
  but otherwise is fairly standard.

- **OB1 2024-05-21, 2024-05-31** Added to resolve an issue where a
  sensor was swapped and `placements.csv` updated to indicate the swap,
  BUT the QC module was still throwing errors.

- **SB2X 2024-05-15, 2024-06-10** Conductivity was calibrated with a
  single point calibration for these two deployments.

- **BD1 2024-06-21** One of the calibrated conductivity columns is weird
  in this data set has "High Range High Range" instead of "High Range".

## Examples

``` r
if (FALSE) { # \dontrun{
setup_example()
} # }
```
