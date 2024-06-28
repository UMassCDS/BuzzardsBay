
# BuzzardsBay 0.1.0.9008

## Completed

* Additional test data 
* `qc_deployment()` now works when  conductivity is calibrated with a single
calibration point.
* Add "calibration_points"  to metadata for conductivity.
* Delete duplicated "High Range" in column heading.
 The BD1 sensor is labeling the column "High Range High Range (μS/cm)" 
  The duplicate "High Range" is now removed for any sensor that has it.

## Pending tasks:

* Update DO calibration to allow end point only calibration and capture 
calibration_points.


* Placement Dates

   A sensor was swapped out and it's creating issues with identifying placement
dates.

   From Kristin 2024-06-25

   One more thing I ran into today. I was running the QC module for OB1. We switched a sensor in between one of the deployments, so I have two separate lines in the "placements" file for the conductivity sensor. First, the final deployment for the first sensor didn't work unless I set the last date it was deployed to be one day after we actually took it in from the field (I assume so that the program did not cut off the data the second the new day turned around). Next, I couldn't run the following deployments through the QC module because it said the serial number didn't match. Here is the error message:
    Error in if (cond_sn != md$cond_device$serial_number) stop("Cond Serial number in csv does not match serial number in ",  : missing value where TRUE/FALSE needed

   So adding another line for one station with new dates and a new serial number doesn't seem to work seamlessly. Is there a better way I should do it? Also is there a way that we can make the code work for that transitory day where sensors are swapped? Do we need to add a time element to the date?
  Examples for this transition are in the OB1 date 2024-05-21 and 2024-05-31. I'm happy to answer any more questions about the swap too.






# BuzzardsBay 0.1.0.9007

* Allow dates in placements.csv to be either month/day/year or year-month-day
* New internal function `format_csv_date()` takes text dates in either
month/day/year or year-month-day and converts to year-month-day text. This is
intended for using eith dates from .csv files that might have been edited with
excel which messes with dates.

# BuzzardsBay 0.1.0.9006

* Add 2024 example data - so now there are two example datasets.
* `setup_example_dir()` return list has new item `deployments` which is a vector
 of deployment directories.  The `deployment` item still exists and is the
 first item. It also sets up both deployment directories and metadatfiles for
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
      * in the conductivity ffile the site id and a number were added to the 
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
