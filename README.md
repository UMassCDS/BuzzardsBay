
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BuzzardsBay

<!-- badges: start -->
<!-- badges: end -->

The goal of **BuzzardsBay** (R package) is to process and analyze data
for the [Continuous Oxygen Monitoring in Buzzards Bay (COMBB)
project](https://www.woodwellclimate.org/project/combb/).

## Installation

You can install **BuzzardsBay** from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("UMassCDS/BuzzardsBay")
```

## Usage

Currently the primary function is `qc_deployment()` it reads in
calibrated data for a deployment and generates files containing merged
and flagged copies of the data. It assumes [this file structure and
naming
convention](https://docs.google.com/document/d/1kJttcEXzpNNknGwjkVwdYHw9LzZyjJ-FaX0CrU7H7NU).
In particular it expects data for a deployment to have this path
`/BB_Data/<year>/<site>/<year>-<month>-<day>/` e.g.
`"~/BB_Data/2022/SR4/2022-07-08"`. It makes no assumption about the path
to base directory (`"BB_Data"`) itself.  
Within the deployment directory there should be a “Calibration/”
sub-directory with the calibrated HOBOware output (ending in `.csv` and
`Details.txt`) for both dissolved oxygen and conductivity/salinity.

Once that’s in place we can process the calibrated data in the
deployment with the code below.

``` r
library(BuzzardsBay)
deployment_dir <- ""  # Provide full path here. Don't include `Calibration/`
qc_deployment(deployment_dir)
```

## Running on example data

Create an example data folder structure and deployment with
`setup_example_dir()`. If you specify a path with the `parent_dir`
argument the example will be created there. Otherwise, as in the example
below, it creates the example files within the location specified by
`tempdir()`.

``` r
paths <- setup_example_dir()  
print(paths)
```

With that in place we can then call `qc_deployment()` on the example
deployment stored in `paths$deployment` which will also be where the
output files are created.

``` r
a <- qc_deployment(paths$deployment)
```

The code above will only work once as `qc_deployment()` will throw an
error if the output already exists. To run again delete all the example
data in `paths$base`.

### Output

`qc_deployment()` writes two identical CSV files and a metadata file to
the deployment directory.

- `Auto_QC_<deployment>.csv` is a permanent record of this state of the
  process and should not be edited.
- `Preliminary_QC_<deployment>.csv` is for subsequent review and
  editing. `Preliminary_` should be dropped from the name when review is
  complete.
- `Metadata_<deployment>.yml` contains the metadata written as a YAML
  file.

#### Tabular data

Here are a few lines of the data written to the two CSV files when using
`setup_example_dir()`.

| Site | Date       | Date_Time           | Gen_QC | Flags | Time     | Time_QC | Temp_DOLog | Temp_DOLog_Flag | Temp_DOLog_QC | Temp_CondLog | Temp_CondLog_Flag | Temp_CondLog_QC | Raw_DO | Raw_DO_Flag | Raw_DO_QC |   DO | DO_Flag | DO_QC | DO_Calibration_QC | DO_Pct_Sat | DO_Pct_Sat_Flag | DO_Pct_Sat_QC | Salinity_DOLog | Salinity_DOLog_Flag | Salinity_DOLog_QC | Salinity | Salinity_Flag | Salinity_QC | Sal_Calibration_QC | High_Range | High_Range_Flag | High_Range_QC | Spec_Cond | Spec_Cond_Flag | Spec_Cond_QC | QA_Comment | Field_Comment |
|:-----|:-----------|:--------------------|-------:|:------|:---------|:--------|-----------:|:----------------|:--------------|-------------:|:------------------|:----------------|-------:|:------------|:----------|-----:|:--------|:------|:------------------|-----------:|:----------------|:--------------|---------------:|:--------------------|:------------------|---------:|:--------------|:------------|:-------------------|-----------:|:----------------|:--------------|----------:|:---------------|:-------------|:-----------|:--------------|
| SR4  | 2022-06-09 | 06/09/22 19:00:00.0 |        |       | 19:00:00 |         |      20.38 |                 |               |        20.84 |                   |                 |   9.60 |             |           | 8.10 |         |       |                   |      107.5 |                 |               |        30.7494 |                     |                   |  30.7506 |               |             |                    |    32947.4 |                 |               |   47281.5 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 19:15:00.0 |        |       | 19:15:00 |         |      20.46 |                 |               |        20.88 |                   |                 |   9.70 |             |           | 8.18 |         |       |                   |      108.8 |                 |               |        30.7432 |                     |                   |  30.7444 |               |             |                    |    32967.4 |                 |               |   47273.0 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 19:30:00.0 |        |       | 19:30:00 |         |      20.24 |                 |               |        20.75 |                   |                 |   9.63 |             |           | 8.12 |         |       |                   |      107.6 |                 |               |        30.8474 |                     |                   |  30.8487 |               |             |                    |    32974.9 |                 |               |   47416.3 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 19:45:00.0 |        |       | 19:45:00 |         |      20.28 |                 |               |        20.79 |                   |                 |   9.67 |             |           | 8.15 |         |       |                   |      108.1 |                 |               |        30.7837 |                     |                   |  30.7850 |               |             |                    |    32939.9 |                 |               |   47328.8 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 20:00:00.0 |        |       | 20:00:00 |         |      20.36 |                 |               |        20.88 |                   |                 |   9.84 |             |           | 8.30 |         |       |                   |      110.2 |                 |               |        30.7465 |                     |                   |  30.7478 |               |             |                    |    32964.9 |                 |               |   47277.6 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 20:15:00.0 |        |       | 20:15:00 |         |      20.60 |                 |               |        21.06 |                   |                 |   9.61 |             |           | 8.12 |         |       |                   |      108.1 |                 |               |        30.6133 |                     |                   |  30.6146 |               |             |                    |    32959.9 |                 |               |   47094.5 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 20:30:00.0 |        |       | 20:30:00 |         |      20.64 |                 |               |        21.21 |                   |                 |   9.43 |             |           | 7.98 |         |       |                   |      106.2 |                 |               |        30.3891 |                     |                   |  30.3905 |               |             |                    |    32845.2 |                 |               |   46786.1 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 20:45:00.0 |        |       | 20:45:00 |         |      20.70 |                 |               |        21.28 |                   |                 |   9.02 |             |           | 7.64 |         |       |                   |      101.7 |                 |               |        30.1322 |                     |                   |  30.1336 |               |             |                    |    32642.3 |                 |               |   46432.0 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 21:00:00.0 |        |       | 21:00:00 |         |      20.76 |                 |               |        21.42 |                   |                 |   8.88 |             |           | 7.53 |         |       |                   |      100.2 |                 |               |        29.9624 |                     |                   |  29.9638 |               |             |                    |    32571.0 |                 |               |   46197.8 |                |              |            |               |
| SR4  | 2022-06-09 | 06/09/22 21:15:00.0 |        |       | 21:15:00 |         |      20.96 |                 |               |        21.56 |                   |                 |   8.73 |             |           | 7.41 |         |       |                   |       98.9 |                 |               |        29.7539 |                     |                   |  29.7554 |               |             |                    |    32460.9 |                 |               |   45910.1 |                |              |            |               |

#### Metadata

This is the metadata derived from the example.

- site: SR4
- deployment: SR4_2022-07-08
- auto_qc_date: 2024-04-26
- logging_interval_min: 15
- timezone: GMT-04:00
- do_calibration:
  - start_time: 06/09/22 12:00:00 PM GMT-04:00
  - start_do_conc: 7.8
  - start_temperature_c: 20.38
  - start_salinity_ppt: 29.61
  - start_meter_titration_value_mg_l: 6.62
  - start_salinity_correction: 0.8402
  - end_time: 06/21/22 11:15:00 PM GMT-04:00
  - end_do_conc: 5.02
  - end_temperature_c: 21.7
  - end_meter_titration_value_mg_l: 4.32
- do_deployment:
  - full_series_name: DO Adj Conc, mg/L
  - launch_name: BBC1_SR4_20659181
  - launch_time: 06/08/22 11:01:41 GMT-04:00
  - calibration_date: 05/16/22 18:17:04 GMT-04:00
  - calibration_gain: 1.04263
  - calibration_offset: 0
- do_device:
  - product: HOBO U26-001 Dissolved Oxygen
  - serial_number: 20659181
  - version_number: 1.08
  - header_created: 03/02/12 14:19:05 GMT-04:00
- cond_calibration:
  - start_cal_cond: 41877
  - start_cal_temp: 20.7
  - start_cal_time: 06/09/22 12:00:00 GMT-04:00
  - end_cal_cond: 45762
  - end_cal_temp: 22.2
  - end_cal_time: 06/21/22 23:15:00 GMT-04:00
- cond_deployment:
  - full_series_name: Salinity, ppt
  - launch_name: BBC1_SR4_20649629
  - launch_time: 06/08/22 11:05:29 GMT-04:00
- cond_device:
  - product: HOBO U24-002 Conductivity
  - serial_number: 20649629
  - version_number: 1.52
  - header_created: 06/26/19 07:42:02 GMT-04:00
