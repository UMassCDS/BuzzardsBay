# Import Calibrated Deployment Data

This function imports calibrated data for a single deployment from its
`Calibrated` sub directory. `import_calibrated_data()` calls distinct
functions (import types) depending on the devices associated with the
deployment in `placements.csv` The called functions are internal to the
package and have the naming structure `import_calibrated_data_[x]` where
`[x]` is an integer.

## Usage

``` r
import_calibrated_data(paths, devices)
```

## Arguments

- paths:

  Path list as returned from
  [`lookup_paths()`](https://umasscds.github.io/BuzzardsBay/reference/lookup_paths.md).
  Only the `import_types` component is used here.

- devices:

  Device information in a list as returned from
  [`lookup_devices()`](https://umasscds.github.io/BuzzardsBay/reference/lookup_devices.md).

## Value

A list with two items the first `d` is a data frame with the calibrated
data containing the following columns.

- Date_Time:

  The date and time of the observation as a string in the format
  `yyyy-mm-dd hh:mm:ss`

- Raw_DO:

  Uncalibrated (measured) Dissolved Oxygen in mg/L

- Temp_DOLog:

  Temperature in Deg. Celsius as recorded by the DO logger

- DO:

  The calibrated (salinity adjusted) Dissolved Oxygen in mg/L

- DO_Pct_Sat:

  Dissolved oxygen percent saturation (calibrated)

- Salinity_DOLog:

  Salinity as recorded by the DO logger in ppt (parts per thousand),
  this is equivalent to PSU (Practical Salinity Units)

- High_Range:

  High Range Conductivity in microsiemens per cm. Note newer loggers may
  call this column "Electrical Conductivity" which is the same thing,
  and even for those loggers it will be called High_Range throughout the
  QC workflow.

- Temp_CondLog:

  Temperature in Deg. Celsius as recorded by the conductivity logger

- Spec_Cond:

  The specific conductivity (new loggers) or specific conductance (older
  loggers) in microsiemens per cm.

- Salinity:

  Salinity as recorded by the Conductivity logger in ppt (parts per
  thousand), equivalent to PSU (Practical Salinity Units) which is the
  units assigned by the newer loggers

The second is `md`, a list of metadata information. Details on the list
contents are available
[here](https://docs.google.com/document/d/1GKw3eq9ALigEcX_AWl4vnlejSzsTiIVHzy6LoKCR1jw/edit?usp=sharing).

## Import Types

### Import Type 0 - Single CSV

The Single CSV import is a fallback in case updates to HOBOware or the
loggers themselves break the other imports. It expects a single CSV file
that contains data for both Salinity and DO and a YAML (`.yml`) file -
described below.

To use this import:

1.  Make sure in `import_types.csv` there's a default line: `default,0`
    This means that if an import type isn't identified for a model
    listed in a placement that the Single CSV import will be used.

2.  In `placments.csv` if you want to use the CSV import use a model
    name that is NOT in `import_types.csv` so the default CSV import is
    used. I recommend using the model name with `-CSV` appended; e.g.
    instead of `MX801` use `MX801-CSV`.

3.  In the deployment's `Calibrated` directory create an appropriate CSV
    and YAML file as described below.

#### CSV file

The CSV file would likely be created with external code or manually from
calibrated output from HOBOWare.

In the CSV file the columns are resolved by name not order and the
import will attempt to resolve several different column naming
conventions. Any of the following should work:

- The canonical column names used by this package: `"Date_Time"`,
  `"Raw_DO"`, `"Temp_DOLog"`, `"DO"`, `"DO_Pct_Sat"`, `"High_Range"`,
  `"Temp_CondLog"`, `"Spec_Cond"`, `"Salinity"`, `"Depth"`,
  `"Latitude"`, and `"Longitude"`. The last three are optional, the rest
  are required.

- Columns names from the MX801 logger. For example by saving the first
  sheet as a CSV.

- Column names from the U24 and U26 loggers. However, when combining
  data from these two loggers into a single CSV the two temperature
  columns will have to be manually renamed to `"Temp_CondLog"`, and
  `"Temp_DOLog"` as they are otherwise indistinguishable.

Please verify carefully that the various DO, Conductivity, and Salinity
columns are properly identified. For example make sure the resulting
"DO" column has the calibrated values and the "Raw_DO" column has the
un-calibrated values.

#### YAML file

In the YAML file the following items are required:

- **calibration_start:** The date and time of the start of the
  deployment. For field calibrated sensors (U24, U26) this is also the
  calibration time. For factory calibrated sensors (MX801) this is NOT
  the calibration time.

- **calibration_end:** As in the above, the end of the deployment and/or
  calibrated window.

- **timezone:** The timezone as reported by the logger and/or
  calibration software. The output from HOBOware uses a GMT offset like
  "GMT-04:00", which is not a broadly supported timezone but is accepted
  here. The MX801 uses a timezone code "EST" which is also accepted
  here.

- **do_device:** Information on the DO sensor or logger with items:

  - **product:** The dissolved oxygen sensor e.g. "HOBO U26-001
    Dissolved Oxygen", "U26-01", or "MX801".

  - **serial_number:** The device serial number.

- **cond_device:** List with information on the conductivity sensor with
  items:

  - **product:** The conductivity sensor e.g. "HOBO U24-002
    Conductivity"

  - **serial_number:** Conductivity sensor serial number Additional
    items that appear in the [metadata
    documentation](https://docs.google.com/document/d/1GKw3eq9ALigEcX_AWl4vnlejSzsTiIVHzy6LoKCR1jw/edit?tab=t.0)
    are permitted and will be retained. Items that do not appear in that
    document will be ignored.

### Import Type 1 - U24, U26

This input works with HOBOware calibrated CSV files from U24 and U26
loggers, and expects to find two CSV files and two `details.txt` files
in the calibration directory. The Dissolved Oxygen files should have
`"Do_"` somewhere in the names while the Conductivity files should have
either `"Cond_"` or `"Sal_` in the names.

Do not include `"_TR_"` or `"_TR."` in the file names as they are used
to indicate Tide Rider location data.

### Import Type 2 - MX801

This is the import type for the MX801 logger, it expects a `.xlxs` file
with combined data from both loggers and on the first sheet, and a
`details.yml` file in the calibrated directory. The YAML file will be
created by users and should have this format:

    calibration_start: 2025-01-02 15:50:02
    calibration_end: 2025-01-04 13:00:02
    timezone: EST
    serial_number: 22145899

`calibration_start` and `calibration_end` define the start and end of
the deployment window - even if no calibration took place. This is a
legacy of the U24 and U26 loggers where the calibrated window and the
deployment window were the same.

The path to an example file can be retrieved with:
`system.file("extdata/2025/BBC/2025-01-04/Calibrated/details.yml", package = "BuzzardsBay")`

In `placements.csv` there should be two lines for the MX801 import. One
each for `"DO"` and `"Cond"` both of which should indicate `"MX801"` as
the model and have the same Serial Number.

To create a local copy of example data for the MX801 import run this in
R:

    example_paths <- setup_example_dir(site_filter = "BBC",
                                      year_filter = 2025)
    deployment_dirs <- example_paths$deployments
    print(deployment_dirs)

To run QC on example data:

    qc_deployment(deployment_dirs[1])

## Tide Rider Import

Tide Riders are mobile sensor platforms that actively control depth in
the water column and move laterally with the tides.

Tide Rider data can be included with any of the above imports, although
currently we only anticipate Tide Riders being equipped with the U24 and
U26 loggers.

Each Tide Rider should be treated as a independent "Site" with a unique
site ID that should be in the sites and placements tables. Tide riders
do not need to be in the import_types table and the serial number for
tide riders is not required in nor used from the placements table.

Tide rider data should be included along with the DO and Conductivity
data in the calibrated directory for the "site". For example
"2025/TRS102/2025-08-14/Calibrated" would hold both the logger and tide
rider data for the TRS102 tide rider ("site") for the deployment ending
on 2025-08-14. The Tide Rider data should be in a CSV file with`"TR"` in
the name isolated from other characters with `"_"` and/or `"."` e.g.
`"data_TR.csv"`; beginning the file with `"TR"` does not count it should
not have `"Cond_"`,`"DO_"`, or `"Sal_"` in the name as those indicate
the calibrated CSV logger files.

The expected columns are listed below. Alternate names are allowed in
the CSV but will be renamed on import to the standard name. Names used
in the original example file are bold.

|                   |                                    |
|-------------------|------------------------------------|
| **Standard Name** | **Alternates allowed in input**    |
| Date_Time         | **Time**                           |
| **Latitude**      | (none)                             |
| **Longitude**     | (none)                             |
| Depth             | Logger Depth, **Logger Depth (m)** |
| TR_Flags          | **Flags**                          |

The `"TR_Flags"` column is required for but not used.
