# BuzzardsBay 1.0.0.9002

Minor changes to reporting:
- Fix bug that misreported proportion of DO under 3 mg/L
- in daily_stats.csv, change precision of Min_Temp and Max_Temp to 2 digits
- in WPP<site><year>.csv, change precision of Saility to 2 digits, and High_Range and Spec_Cond to whole numbers

# BuzzardsBay 1.0.0.9001
2025-12-30

## Tide Rider Import

 Tide Riders are mobile sensor platforms that actively control depth in the
 water column and move laterally with the tides.

 Tide Rider data can be included with any of the standard imports 
 (Basic CSV, U24/U26 CSV, and MX801 Excel files).
 Although currently we only anticipate Tide Riders being
 deployed with the U24 and U26 loggers.

 Each Tide Rider should be treated as a independent "Site" with a unique
 site ID that should be in the sites and placements tables. Tide riders
 do not need to be in the import_types table and the serial number
 for tide riders is not required in nor used from the placements table.

 Tide rider data should be included along with the DO and Conductivity
 data in the calibrated directory for the "site".  For example
 "2025/TRS102/2025-08-14/Calibrated" would hold both the logger and tide rider
 data for the TRS102 tide rider ("site") for the deployment ending on
 2025-08-14. The Tide Rider data should be in a CSV file with "TR" in the name
 isolated from other characters with "_" and/or "." e.g. "data_TR.csv";
 beginning the file with "TR" does not count.  
 The Tide Rider data file should not have "Cond_","DO_", or "Sal_" in the name 
 as those indicate the calibrated CSV logger files.

 Tide Rider standard column names and accepted alternate names that will be 
 renamed on import to the standard name. 
 
 Names used in the original example file are in bold.

| Standard Name | Alternates allowed in input |
|-------------:|----------------------------------:|
| Date_Time | **Time** |
 | **Latitude** | (none)  |
 | **Longitude** | (none) |
| Depth  | Logger Depth, **Logger Depth (m)** | 
 | TR_Flags | **Flags** |

 The "TR_Flags" column is checked for but not used.

This information is also available in the Tide Rider section of the 
help for `import_calibrated_data()`. 

## Other changes

* Dropped some snapshot testing that wasn't consistent across platforms.
* Updated test for `get_file_hashes()` to make it work across platforms.
* Bumped to version 1

# BuzzardsBay 0.1.0.9032
2025-10-08

* `make_deployment_report()` - called by `qc_deployment()` - and 
`report_site()` both now create html output in a temporary location and then 
copy it to the final location.  The hope is that this will fix the bug where
sometimes the reports disappear from the OneDrive shortly after being created.
See issue #24.

* Fixed bugs in the CSV and MX801 import that caused the time to be dropped 
from date-time strings at midnight. (#25)

* `stitch_site()` now assumes that if a date-time row is missing the time that
it is midnight and adds the "00:00:00" back in. (#25)

I haven't fully tested these as I can't replicate the disappearing 
files in my test environment and it was logistically a hassle to add the 
data necessary to test `stitch_site()`.  Please report any ongoing issues.

# BuzzardsBay 0.1.0.9031

* Added import_type to the metadata created by `qc_deployment()`

* For MX801 imports (type  2) dropped warning when less than 95% of the data is
  in the calibrated window. 
  With these loggers the data typically extends well beyond the deployed
  window, so the warning was always triggered and not informative. 

* Added example-data vignette.

# BuzzardsBay 0.1.0.9030

### Change to **MX801** import.  

  Switch to using a YAML file (`.yml`) when importing metadata from MX801, 
  ignoring the details sheet in the excel file that was previously
  used.
  
  This change was  made to: 
  (1) allow users to specify the deployment window in the YAML file
  (use `calibration_start` and `calibration_end`); and 
  (2) make the import less susceptible to possible future changes in the 
  HOBOware details sheet.  This part of the import was complicated and 
  likely to break with minor changes to the format.

  The new `details.yml` file in the calibrated directory will have to be 
  created by users and should have this format:
   
  ```
  calibration_start: 2025-01-02 15:50:02
  calibration_end: 2025-01-04 13:00:02
  timezone: EST
  serial_number: 22145899
  ```
  The path to an example file can be retrieved with:
    `system.file("extdata/2025/BBC/2025-01-04/Calibrated/details.yml", package = "BuzzardsBay")`
  
### Change to **CSV** import. 

Previously the CSV export expected the 
`calibration_start` and `calibration_end` times in the YAML file to match the
 date and time of the first and last record in the file.
 Now, it does not need to match and any rows before `calibration_start` 
 or after `calibation_end` **will be dropped**.
 
### Other

Document the three import types and file formats in `qc_deployment()`

# BuzzardsBay 0.1.0.9029

Implement changes to analysis module requested in April

Changes to `stitch_site()`:

- Fail more politely when run on a site with no QC data.
- Quote strings when writing Archive and WPP files, as comments sometimes include
commas, which are a no-no in CSVs. Quoting makes these files robust. There's no need
to quote strings in the core files, as they don't have comment fields.
- Always use blank, not #N/A in CSVs.
- Reject any rows where Cal = 1 unless Gen_QC is 11 or 12.
- Change Unique_ID to <Site>_<Date>_<Time> to make it easier to compare across sites.
Instead of serial numbers, use the form "AB2_2024-08-06_14:40:00".

Changes to daily stats

- Add minimum and maximum temperature.

Seasonal stats

- Report_site now writes a seasonal stats CSV in addition to including stats as a table in report.
- Round mean duration of DO to 0.1 hours.
- Add standard deviation of DO.
- Change text of % data missing to "percent of rows with missing data".
- Add an option to report_site ('clip') to restrict dates in seasonal statistics. Plots
are not clipped to these dates.
- Now reports date range (whether or not clipped) in seasonal stats; if clipped, there's a
footnote in the report.

Changes to report:

- Move figure captions above figures (which looks odd!).
- Add vertical green lines marking starts of deployments to Fig. 2. ***Note***: this
required adding a new column ("Deployment") to the core data file, as this file doesn't contain QC
data (I added it to all three files for consistency). Deployment is 1 when Gen_QC is 12, and empty
otherwise. As a result of this change, all previously-stitched sites will have to be re-stitched. You'll get an
error reminding you to do this for sites where it hasn't been done.
- Add a time series of salinity by date, with deployment lines. This plot is optional: use 
`salinity = FALSE` to disable it. I've added the plot after daily salinity, and before the two
Baywatchers plots.
- Only "deep" Baywatchers samples are included (those where S_D = 'D').
- Baywatchers points are now only interpolated to points within 10 minutes. If none are available, these
points will be dropped.

# BuzzardsBay 0.1.0.9028

- Change default PDF engine in the hopes of making report_site work on Macs. This should
have no effect on Windows machines.

# BuzzardsBay 0.1.0.9027

- Fix a bug that occurred when there wasn't a gap between deployments

- Correct Fig. 8 caption

# BuzzardsBay 0.1.0.9026

- Fix formatting of First day warmer than/colder than

- Change tinytex to suggests (as it's not needed for QC side) and check
for installation in report_site, installing both it and separate TinyTeX
software on machine. 

- Add description of how to install TinyTeX in README.

# BuzzardsBay 0.1.0.9025

* Add `tinytex` to imports in DESCRIPTION to guarantee that `tinytex` is 
 installed when **BuzzardsBay** is installed.

* The simple CSV import used by `qc_deployment()`  no longer 
requires a `cond_calibration` item in the YAML file, 
which was not intended to be required and was ambiguously defined. 

* Fixed minor bug in `setup_example_dir()` that had no impact on users 
of the package but caused the function to fail with some inputs.

# BuzzardsBay 0.1.0.9024

Includes the initial complete version of the **Analysis Module**. Additions include:

- `report_site` now produces the seasonal report as a PDF with a table of seasonal statistics
and a series of plots
- `extract_baywatchers` processes Baywatchers data from the original Excel file for a given year
- various bug fixes and improvements

For more details, see `README`. 

# BuzzardsBay 0.1.0.9023

## Add checks to `qc_deployment()` for Depth column.
  *  If Depth is less than `min_depth` (defaults to 0) write 7 to `Depth_QC`,
  add `Wl` flag, and write `91` in `GEN_QC`. 
  * If Depth is greater than `max_depth` (defaults to 9) write 7 to
  `Depth_QC`, add `Wh` to flags, and write `9999` to `GEN_QC` 
  * As depth can produce either a `9999` or `91` in `GEN_QC` precedence with
  other `GEN_QC` values as follows.  
    * If `GEN_QC` is empty write the new values.
    * If `GEN_QC` is `9999`  and depth results in `91`  the result is `9999` 
    This ensures that a reviewer responds to all raised flags.
    * If `GEN_QC` is `9` and depth produces `91` the `91` takes precedence, 
    because it's more informative
    * If `GEN_QC` is `9` and depth produces `9999` the `9` takes precedence.
  
## Required file changes
Add the following to `/bb_parameters.yml` when updating to this version.

```
min_depth: 0
max_depth: 9
```

# BuzzardsBay 0.1.0.9022

More bug fixes

- Certain missing deployments (those with a date folder that contained a metadata file but no QC file) caused a crash instead of being politely noted.
- Text fields such as QA_Comment were inconsistently reported as #N/A for archive and WPP result files.
- Bad QC codes for Gen_QC weren't caught, though other bad QC codes were.
- Test more carefully for errors in test suite.

# BuzzardsBay 0.1.0.9021

Minor bug fixes

- Always use uppercase for site abbreviations.
- Check_site now checks for outdated reports and alerts about them. Previously, it was possible to run stitch_site and report_site, then edit deployment data and rerun stitch_site without report_site, and end up with outdated reports and no way to know that they were.
- Fixed a bug in Duration_Under_6 (and 3) in daily stats: runs to or past midnight would report 10 minutes too few on the day they started, as midnight is treated as tomorrow, so the last sample wasn't counted.


# BuzzardsBay 0.1.0.9020

This update introduces the **Analysis Module**. This extension stitches deployments
for a site and year, producing three result data files (archive, WPP, and core). 
It has a facility to check that result files are up to date. And it produces
a daily statistics file and a report with seasonal stats and a series of 
graphs.

Included:

- `stitch_site()`. Stitches deployments and creates result data files.

- `check_site()`. Checks to see if deployment data have changed since 
`stitch_site()` was run.

- `report_site()`. Produces a CSV of daily stats and PDF report with
seasonal stats and graphs. **This function is only partially implemented**
at this point: it only produces the daily stats file.

For more details, see `README`.

**Note**: you'll need to update `sites.csv` in your `<year>\Metadata\` folders
to include `WaterBody`. If `WaterBody`, `Latitude`, or `Longitude` are missing, 
`stitch_site()` will still run, but will report them as missing.

# BuzzardsBay 0.1.0.9019

This update and the bug this fixes have no impact on users.

* Fixed bug [#11](https://github.com/UMassCDS/BuzzardsBay/issues/11) in 
  `lookup_paths()` that caused it to fail when using arguments other than
  `deployment_dir`.  Also now it requires either `deployment_dir` or
  `base_dir` arguments - but not necessarily `year`, `site`, or 
  `deployment_date` and it will return the paths to all items that it 
  is able to resolve.  
  
* Added unit test for `lookup_paths()`.

# BuzzardsBay 0.1.0.9018

* Fixed bug in Salinity check that could cause 
  the low variation in salinity flag (`Slv`) to overwrite or duplicate 
  other salinity flags.
  This bug was first detected in the MX801 import but 
  has been present for all previously run QAQC. 
  It only affects salinity, and only in rows 
  where low variation in salinity is detected. 
  The low variation flag should always be correct but 
  other salinity flags might be either dropped or erroneously show up 
  along with the low variation in salinity flag. 
  Non-salinity flags were not affected. 
  
* Suppressed confusing chatter from `readxls::read_excel()` that showed up when
  calling `qc_deployment()` on output from MX801 logger.
  
* Updated test for MX801 logger output. 
  
  
# BuzzardsBay 0.1.0.9017

* Documentation edits
* Added additional options to `get_expected_column_names()` to support 
  aggregation and analysis modules.
* Fixed bug in `parse_mx801_details()` so that it works regardless of how the 
  the carriage returns or new lines within cells are encoded.  It previously 
  worked with carriage return ("\r") but not new line ("\n").  I expect 
  the differences in the input files may trace back to whether calibration was
  done on a mac or PC but that's just a guess.
  


# BuzzardsBay 0.1.0.9016

Fixed bug in `format_csv_date_time()` that caused it to drop the time component
at midnight.  E.g. "8/7/2024 0:00" became "2024-08-07".  

# BuzzardsBay 0.1.0.9015

### CSV Import

A new simple, CSV import is now supported.
It is a fallback in case updates to HOBOware or the loggers
themselves break the targeted imports.
The simple CSV import expects a CSV file and a YAML (`.yml`) file.

This is implemented as import type 0, which uses the internal function
`import_calibrated_data_0()` which is called by `import_calibrated_data()`,
which, in turn, is called by `qc_deployment()`.

To use this import:

1. In `import_types.csv` update (or add) the default line:
`default,0` This means that if an import type isn't identified for a model
listed in a placement that the CSV import will be used.
2. In `placments.csv` if you want to use the CSV import use a model name
that is NOT in `import_types.csv` so the default CSV import is used. 
I recommend using the model name with `-CSV` appended; e.g. 
instead of `MX801` use `MX801-CSV`.
3. In the deployment's `Calibrated` directory create an appropriate CSV and 
YAML file as described below.

#### CSV file

In the CSV file the columns are resolved by name not order and the import
will attempt to resolve several different column naming conventions. Any 
of the following should work:

* The canonical column names used by this package:  "Date_Time", "Raw_DO", 
  "Temp_DOLog", "DO", "DO_Pct_Sat", "High_Range", "Temp_CondLog",
  "Spec_Cond", "Salinity", "Depth", "Latitude", and "Longitude". The last 
  three are optional, the rest are required.
* Columns names from the MX801 logger. For example by saving the first sheet
  as a CSV.
* Column names from the U24 and U26 loggers. However, when combining data
  from these two loggers into a single CSV the two temperature columns will
  have to be manually renamed to "Temp_CondLog", and "Temp_DOLog" 
  as they are otherwise indistinguishable.

If using other column names please verify carefully that the various DO, 
Conductivity, and Salinity columns are properly identified. For example make
sure the resulting "DO" column has the calibrated values and the "Raw_DO" column
has the uncalibrated values. 

#### YAML file

In the YAML file the following items are required:

* **calibration_start:** The date and time of the start of the deployment.
  For field calibrated sensors (U24, U26) this is also the calibration time.
  For factory calibrated sensors (MX801) this is NOT the calibration time.
* **calibration_end:** As in the above, the end of the deployment and/or 
  calibrated window.
* **timezone:** The timezone as reported by the logger and/or calibration 
  software. 
  The output from HOBOware uses a GMT offset like “GMT-04:00”,
  which is not a broadly supported timezone but is accepted here.
  The MX801 uses a timezone code "EST" which is also accepted here.
* **do_device:** Information on the DO sensor or logger with items:
  * **product:** The dissolved oxygen sensor e.g. 
  "HOBO U26-001 Dissolved Oxygen", "U26-01", or "MX801".
  * **serial_number:** The device serial number.
* **cond_device:** List with information on the conductivity sensor with items:
  * **product:** The conductivity sensor e.g. "HOBO U24-002 Conductivity" or 
  "U24-002"
  * **serial_number:** Conductivity sensor serial number.
  
Additional items that appear in the 
[metadata description document](https://docs.google.com/document/d/1GKw3eq9ALigEcX_AWl4vnlejSzsTiIVHzy6LoKCR1jw/edit?tab=t.0)
are permitted and will be retained. Items that do not appear in that document
will be ignored.


# BuzzardsBay 0.1.0.9014

* Add MX801 import and example data these were from short trial runs.
  * Add data to `extdata/2025/BBC`
  * Update sites, placements, and import_types tables.
    Site information for BBC is not accurate/real.
    I copied info from another site. 
  * Several changes will need to be made to inputs to use it.
    * Add a line `MX801,2` to the `import_types.csv` table.
     This tells the `qc_deployment()` to use a different import function for
     the `MX801` loggers.
    * In the placements table the `MX801` logger will appear twice for each 
     placement, once for `DO` and once for `Cond`. For example:
     
     ```
     BBC,22070944,MX801,DO,1/1/25,
     BBC,22070944,MX801,Cond,1/1/25,
     ```
     Indicates that the logger with serial number `22070944` was deployed at site
     `BBC` on `1/1/25` Dates can also be written as `2025-01-01`, which is the 
     standard format for this package; but since excel tends to re-write them 
     in the `1/1/25` format that is also accepted.
    
* Add faked tide rider deployment data: `WFH/2024-04-09/`
   * Dropped many redundant records.
   * Made fake calibrated DO and Cond data to accompany it.
   I'm not sure all the metadata was fully updated in the fake data. 
  
* Add example data for aggregation and analysis module and empty test for
  those functions. These are the final QC CSV and metadata YAML files 
  for several deployments in sites `AB2` and `E33`.  These sites and the 
  associated loggers were also added to `placements.csv` 
  using an arbitrary date that is consistent with example data.  
  
  Use the following to setup directories to test against these:
  ``` 
  example_paths <- setup_example_dir(year_filter = 2024, site_filter = "AB2")
  site_dir <- dirname(example_paths$deployment)
  ```
  Or
  
  ```
  example_paths <- setup_example_dir(year_filter = 2024, site_filter = "E33")
  site_dir <- dirname(example_paths$deployment)
  ```

  
# BuzzardsBay 0.1.0.9013

* Drop `Sm` flag (Salinity data missing). When salinity data is missing set
the `DO_Calibration_QC` column to 34.

* Extend y axis of interactive plot by 5% of the range of data so that there is 
a slight buffer around the data.

* Add tests for consistent CSV output for RB1 2023-06-09. 

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
