# Setting up and using example data

Example data files are included with the **BuzzardsBay** package to
facilitate code development and testing. You can also use this example
data to play with the package functions independent of a pre-existing or
important data archive.

### Setup

Load the package:

``` r
library(BuzzardsBay)
```

### All the example files

To put all the example data in the package in one large example data
store with many files:

``` r
paths <- setup_example_dir()
```

by default it will be set up in a path created by
[`tempdir()`](https://rdrr.io/r/base/tempfile.html) but you can also use
the `parent_dir` argument to specify where you want it created.

### A subset of example files

You can use combinations of the filter arguments to specify a subset of
the data you want to include in the example data store. This will be
quicker and use less disk space than including all the files.

For example to get a single deployment:

``` r
paths <- setup_example_dir(site_filter =  "RB1",
                           deployment_filter = "2023-06-09")
print(paths$deployments)
qc_deployment(paths$deployments[1])
```

Or to get all the deployments for site WH1X:

``` r
paths <- setup_example_dir(site_filter =  "WH1X", delete_old = TRUE)
print(paths$deployments)
```

`delete_old = TRUE` was added to clear out the prior example data and is
useful if you want to reset the example - perhaps clearing out
previously run reports and QC files.

------------------------------------------------------------------------

## Available example datasets

These are grouped into examples for the analysis module and the qc
module. The formats of the two sets of files is different so each
example deployment will only work for one of the two sets of functions.

### Aggregation and Analysis Module

For these deployments the test data consists of the final QC CSV and
YAML files but NOT the calibration files. They are to test
[`report_site()`](https://umasscds.github.io/BuzzardsBay/reference/report_site.md),[`check_site()`](https://umasscds.github.io/BuzzardsBay/reference/check_site.md),
and
[`stitch_site()`](https://umasscds.github.io/BuzzardsBay/reference/stitch_site.md).
They don’t work with
[`qc_deployment()`](https://umasscds.github.io/BuzzardsBay/reference/qc_deployment.md).

#### AB2

*2024-08-16, 2024-08-27, 2024-09-05* 3 consecutive deployments

#### E33

*2024-07-09, 2024-07-23* 2 consecutive deployments, second is two weeks
long

#### WH1X

*2023-06-09, 2023-06-16, 2023-06-23* 3 consecutive deployments

### QC Module

These files work with
[`qc_deployment()`](https://umasscds.github.io/BuzzardsBay/reference/qc_deployment.md).
There are a ton of files here to support the three different import
types and to demonstrate issues that have since been resolved.

#### Import Type 0

This was the last import type added but I assigned it a 0 as it’s a fall
back simple import. It expects one CSV and one YAML file.

##### SIM 2025-01-04

“SIM”” is a made up site with data reformatted from another site to
match the simple import inputs.

#### Import Type 1 - U24 and U26

This was the original import type supported by the package. These are
based on two separate DO and Cond. loggers. For each logger there is a
CSV with the data and a details text file with metadata from the
calibration.

##### RB1 2023-06-09

First example data for U24 and U26 loggers.

##### OB1 2024-05-21, 2024-05-31

These two were added to resolve an issue where a sensor was swapped and
`placments.csv` updated to indicate the swap, BUT `qc_deployment)` was
still throwing errors.

##### OB1 2024-07-30

The conductivity meter had issues so a fixed (average) salinity was used
for calibration breaking the QC code.

##### SB2X 2024-05-15, 2024-06-10

Conductivity was calibrated with a single point calibration on these two
dates instead of the standard 2-point calibration.

##### BD1 2024-06-21

This sensor produced a weird column name:

    From Kristin:
    I was working through BD1 and got the error message: 

    `Error in qc_deployment(deployment_dir) : The calibration data data is 
    missing some expected columns: "High_Range"`

    I believe it comes down to the fact that whenever I export .csv files from 
    this particular sensor, it names the column "HIgh Range High Range (?S/cm)"
    as opposed to the normal "High Range (?S/cm)." If I try to manually adjust
    this, it screws up the dates saved in the .csv and I think spawns some other
    issues with the code. I am going to try to figure out why this particular
    data file exports that heading slightly differently, but could the code be
    adjusted to still recognize it if "High Range" is repeated?

    If you want to look at the data I'm working with, it's BD1 2024-06-21.

##### OB9 2024-07-31

Added to resolve a plot y axis limit that expanded to include -888.88
instead of treating that data as NA and thus not plotting it.

    "OB9 for 2024-07-23 is a really good example of a dataset that has a sensor 
    malfunction written in, so the graphs are difficult to read."
    (the sensor error code -888.88 is getting plotted resulting in a massive 
    yrange on the plot).

#### Type 2 (MX801)

##### BBC 2025-01-04, 2025-01-26, 2025-01-27)

Example output from the new MX801 logger which has a different format
from the U24 and U26 loggers, and logs both conductivity and DO on one
device. There are several possible calibration possibilities.

- 2025-01-04 (2, 2) - two point calibration for both DO and Cond.
  calibration. I think this is the most common type.
- 2025-01-26 (2, 3)- two points for DO and three points for Cond.
  calibration.
- 2025-01-27 (2, 1) - one point for DO and two points for Cond.
  calibration.

Note, I think BBC id a fake site. These are real data from short tests
of the loggers.

See: the [BBC README.md
file](https://umasscds.github.io/BuzzardsBay/articles/2025/BBC/README.md)
for more details.

##### BBC 2025-02-14

More example output from MX801 logger. This one uses different line
endings inside cells than the previous three files.  
The change in line endings prevented if from being processed correctly
with `parse_mx901_details()` prior to bug fixed in 0.1.0.9017.

##### OB1 2025-07-31

This file was added as an example of a weird date-time bug where
sometimes date-times aren’t processed properly. We think the problem is
that at midnight the time component of the date-time is dropped.

#### Tide Rider

##### WFH 2024-04-09

This is the first example of tide rider output I receeived. The
TR_WFH_20240409_TRSX01.csv was from Michael Jakuba and emailed to me by
Kristin Huizenga on 2024-12-05.

It contained high frequency of observations that I resampled at 10
minute intervals. The other calibrated data files are hacked copies from
a separate deployment.  
See data-raw/make_fake_tide_rider_calibration_dir.R for how these files
were generated.

I decided to wait until I had real logger and tide rider data collected
at the same time before implementing the tide rider module.
