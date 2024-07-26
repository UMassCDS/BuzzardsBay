## Pending tasks:

* Update DO calibration to allow end point only calibration and capture 
calibration_points? 
* Allow single point calibration with DO.
* Figure out what to do if both DO and Cond have single point calibration - 
in which case either the start or the end of the calibration window will be
missing.
* Calculate conductivity calibration ratio - pulling from raw data.
* Update plotting:
    * Use sunrise and sunset to determine day and night hours.
    * Add tide plot.
* Create PDF output.

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
