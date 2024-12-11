# BuzzardsBay 0.1.0.9013

* Drop `Sm` flag (Salinity data missing). When salinity data is missing set
the `DO_Calibration_QC` column to 34.

* Extend y axis of interactive plot by 5% of the range of data so that there is 
a slight buffer around the data.

* Add tests for consistent csv output for RB1 2023-06-09. 

# BuzzardsBay 0.1.0.9012

## Necessary file updates for this version

* New required global parameter file:  `<base_dir>/bb_parameters.yml`
 controls flag parameters.
* Similar files can be created in site directories to set site specific values.
  Site versions only need to set the values that differ from the global values.
 
* New required import type table `<base_dir>/import_type.csv` 
 
To create the required files:

```
base_dir <- "path to base directory" # set this
create_parameter_file(base_dir)
import_type_file <- system.file("extdata/import_types.csv", package = "BuzzardsBay")
file.copy(import_type_file, base_dir)
```
  
## Parameters

The parameters that are used while flagging issues in the data are now user
configurable both through a global parameter file or site specific parameter 
files. See note above on creating the global parameter file above.

To override the global values for a site create an identically named 
YAML file in the site directory (`<base_dir>/<year>/<site>`) and set the 
values there.  I recommend only including the values in the site specific file
that you want to change for that site (don't copy the entire file).

For an explanation of all the parameters see the help for `bb_options()`

## Sites with no salinity data

`qc_deployment()` now works with deployments calibrated with a fixed salinity
value.  
In these cases all the salinity related data will be `NA`
in the output from `qc_deployment()`.
This is triggered when either
(1) `Salinity value (ppt)` item is in the calibrated DO details file.
(2) `Salinity` column is missing in the calibrated DO data.


## Example Data

Added OB9 2024-07-23 as an example of a deployment with -888.88 
sensor error values throw off the plot range.

Added OB1 2024-07-30, a deployment where DO is calibrated with a single, fixed 
salinity value.

## Flags 

Added checks for error values in calibrated  DO and Salinity. 
Previously the error codes (-888.88) were only flagged in the uncalibrated
versions of these columns, but the new example data shows them only 
in the calibrated values.

Fixed bug in flags that caused non-immediate rejection flags to overwrite 
immediate rejection flags in the "Flags" column for some columns when 
both types of flags were thrown.  Now and previously the "Gen_QC" column 
was correctly set to 9 when there were immediate rejection flags - even when
previously the flags themselves might have been overwritten.

## Plotting

The plots now set the y-range to the range of the data 
excluding the values that have been flagged as sensor errors (-888.88) and 
constrained based on global parameters `plot_max_do`, `plot_min_do`, 
`plot_max_sal`, `plot_min_sal`, `plot_max_temp`, and `plot_min_temp`.

The interactive plots now include red circles for the last observation of
the prior deployment and the first of the current deployment, and black
circles for jumps.

## Refactoring

The `qc_deployment()` function was broken into smaller
functions. Importing the calibrated data is now done with several sub-functions
in a manner that makes it easier to define different import mechanism for 
different logger types. 

* New `lookup_paths()` function generates paths to all kinds of files. 
  Many are deployment specific. 
  The returned list also includes `deployment_date`, 
  `site`, and `year` which are closely related to the paths.
* Big chunks of `qc_deployment()` were moved to other internal
  functions that aren't intended to be called by package users directly.
  * New `import_calibrated_data()` is called to read
  the calibrated data.  It calls numbered helper functions to read the data
  based on the model types stored in `placements.csv` and the `import_type.csv`
  table which crosswalks the model numbers to an input type integer. 
  * New `import_calibrated_data_1()` imports the first type of calibrated data. 
  Which is the HOBOware CSV and details.txt files we've been working with.
  * An anticipated `import_calibrated_data_2()` function will import the MX801 
  logger's excel file output.
  * New function `read_and_format_placements()` imports the `placements.csv`  
   file and cleans up formatting issues. 
  * New function `lookup_devices()` returns the device names and serial numbers
  for a given deployment from `placements.csv`.
  * New required parameter file `import_type.csv` is stored in the base
  directory - it's not year specific.  It connects device models from placements
  to an import type and thus provides a mechanism for importing from different
  formats associated with different logger models. 
  
## Time
  * `convert_to_utc()` renamed `apply_timezone()` and now handles both GMT
  offset timezone definitions (`"GMT-04:00"`) and timezones (`"EDT"`)
  
# BuzzardsBay 0.1.0.9011

* Fix bug with date times in prior deployment.
Problem was that excel is changing the date format for the prior deployment 
which when read to add to report plots resulted in an error.

  * Add example data BD1/2024-09-23 (target) and BD1/2024-09-17 (prior deployment)
  * Add test to reproduce bug
  * Add new function `format_csv_date_time()` used to cleanup date time data
   that is either in the expected format or in the format excel changes it to.
   This is similar to `format_csv_date()` but works for date-time columns.
  

# BuzzardsBay 0.1.0.9010

* Fix namespace bug.  `tide_station_info` is a dataset included in the package but was erroneously listed as an exported object. This caused the package to fail to install cleanly. 

# BuzzardsBay 0.1.0.9009

* New `convert_to_utc()` allows converting the local date times to UTC
utilizing the GMT offset that HOBOware uses in place of a timezone. 

* New function `is_daylight()` returns TRUE for date-times that
correspond to daylight.

* Update day and night plotting in reports to reflect actual sunrise and 
sunset time and increase contrast between day and night shading.  

* Add functions for estimating and plotting tide height:  `get_tideheight()` and
`plot_tide_sun()` NOTE, however, that due to limitation in the **rtide** 
package it doesn't work for most of the tide stations in Buzzards Bay and tide
height has not been added to the reports.

* Reports now include any portion of the prior deployment that is within six
hours of the current deployment.  In the static plots the last observation of
the preceding deployment and the first of the current are both highlighted with
a red circle.


# BuzzardsBay 0.1.0.9008

* Add a bunch more test data see `setup_example_dir()` for a description 
of the test data files and why they were added.
* Update `setup_example_dir()` so that a subset of the data can be specified,
in which case only that data is copied into the example directory.
* `qc_deployment()` now works when  conductivity is calibrated with a single
calibration point.  DO is not set up this way yet, and there is a conceptual
problem that if both DO and Cond. use single point calibration than 
`qc_deployment()` cannot determine the start and end of the calibration window.
* Add "calibration_points"  to metadata for conductivity.
* Delete duplicated "High Range" in conductivity column heading if present.
 The BD1 sensor is generating a "High Range High Range (μS/cm)" column.
* Fix bug that caused sensor swaps to result in rejected placements due 
to overly strict data comparison with placements table.
* Replace "temperature Temp" in calibrated CSV headings with "Temp" similar to
the "High Range" issue this appears in some of the calibrated files for example
in Ob1/2024-05-31 and subsequent deployments in the conductivity file.
* Allow serial numbers to be missing from calibrated file headings.  Again
as in OB1/2024-05-31 calibrated conductivity. If they are missing then the
SN is pulled from the details file to populate the metadata and the two are 
not checked against each other.


# BuzzardsBay 0.1.0.9007

* Allow dates in `placements.csv` to be either month/day/year or year-month-day
* New internal function `format_csv_date()` takes text dates in either
month/day/year or year-month-day and converts to year-month-day text. This is
intended for using with dates from CSV files that might have been edited with
excel which messes with dates.

# BuzzardsBay 0.1.0.9006

* Add 2024 example data - so now there are two example datasets.
* `setup_example_dir()` return list has new item `deployments` which is a vector
 of deployment directories.  The `deployment` item still exists and is the
 first item. It also sets up both deployment directories and metadata files for
 each year.
* Fixed bug in the QAQC report code that caused temperature flags from the 
DO logger to be considered both temperature and DO flags when plotting.
* Updated `qc_deployment()` and helper functions to handle changes in 
CSV file column names between 2023 and 2024 example data.  
It will now work with both formats.

# BuzzardsBay 0.1.0.9005

* Minor edits to README 
* Updated `parse_do_details()` and `parse_cond_details()` 
    * Work with new 2024 example files 
    * Have greater flexibility in identifying series names in each file.
      * in the conductivity file the site id and a number were added to the 
      series name. 
      * in the DO file "Conc" was dropped from the series name that is now: 
      "Series: DO Adj, mg/L""
    * For both types of files the old and new versions should both be processed
    correctly with the updated code.
    
    
# BuzzardsBay 0.1.0.9004

* Add `bb_options()` for setting and retrieving global parameters which are
  stored in a private environment, `bbp`.
* Move auto qc parameters from `[qc_deployment()] and helper functions into
  global parameters.
* Add `tide_station_info` dataset containing locations of NOAA tide stations 
  in Buzzard's bay.
* Add `inst/rmd/QAQC_report.rmd` with plots and summary information to
  facilitate quality control and quality assurance.
* Add `make_deployment_report()` to make QAQC report from data in a deployment
  directory.
* `qc_deployment()` now makes the report automatically unless the new `report`
  argument is set to `FALSE`.


# BuzzardsBay 0.1.0.9003
2024-05-10

* Update example dataset. In prior example data the Conductivity didn't match
  in the DO and Cond. data and it should.
* Update Details.txt processing to work with newer data that has different 
  line endings.  It now works with any combination of CR and LF line endings.
* Add test for consistent conductivity and dropped duplicate conductivity 
  column.
* Add test for consistent calibration start and end time in the two details
  files and consolidated the start and end times in the metadata file.
* Drop <data>_flag  columns.   "Flags" covers all flags.
* Adopt standard "year-month-day" date, and "year-month-day h:m:s"
  date time formats everywhere.
* Add more checks for consistency against sites table and placements table.
  * Logger SN's must be in placement table at the site indicated by the 
    deployment path.
  * Deployment date from path must match date of last observation in data.
* Add range checks against sites table for DO, both Temperature Columns,
  DO Pct. Saturation, and 
* Add DO ratios to metadata - this is the 
      "meter/titration value (mg/L)" divided by the "DO conc"
       from the DO details.txt file created by HOBOware for both the 
       start and end calibrations
* Add `sites.csv` and `placements.csv` to example data and to files created
  by `setup_example_data()` 
* Cut off the pre and post calibration observations from the head and tail of 
   the file. 
* Add  "pct_calibrated", "n_records", "pct_immediate_rejection", and
  "pct_flagged_for_review" to metadata.
* Add warning if "pct_calibrated" is less than 95.


# BuzzardsBay 0.1.0.9002

* Add `README.Rmd` and `NEWS.md` files.
* Update temperature flags so they indicate which dataset they are associated 
with.

# BuzzardsBay 0.1.0.9001

Initial package
