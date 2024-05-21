
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BuzzardsBay

<!-- badges: start -->
<!-- badges: end -->

The goal of **BuzzardsBay** (R package) is to process and analyze data
for the [Continuous Oxygen Monitoring in Buzzards Bay (COMBB)
project](https://www.woodwellclimate.org/project/combb/).

## Installation

You can install or update **BuzzardsBay** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("UMassCDS/BuzzardsBay")
```

## Usage

The primary function is `qc_deployment()` it reads in calibrated data
for a deployment and generates files containing merged and flagged
copies of the data, and an html report with plots of the data.

`qc_deployment()` and the **BuzzardsBay** package in general assume [a
specific file structure and naming
convention](https://docs.google.com/document/d/1kJttcEXzpNNknGwjkVwdYHw9LzZyjJ-FaX0CrU7H7NU).

In particular:

- All the data associated with a deployment should be stored in a
  deployment directory with a path
  `/BB_Data/<year>/<site>/<year>-<month>-<day>/` e.g.  
  `"~/BB_Data/2022/SR4/2022-07-08"`.  
- The path to base directory and it’s name (`"BB_Data"` in example) can
  be any valid path.
- Within the deployment directory there should be a “Calibration/”
  sub-directory with the calibrated HOBOware output (ending in `.csv`
  and `Details.txt`) for both dissolved oxygen and
  conductivity/salinity. The dissolved oxygen files should have `DO_` in
  their name and the salinity files should have `Cond_`, `Con_` or
  `Sal_` in their name.

Once that’s in place we can process the calibrated data in the
deployment and generate the html report with the code below.

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
error if the output already exists. To run again create a fresh example
directory with: `setup_example_dir(delete_old = TRUE)`

### Output

`qc_deployment()` writes two identical CSV files, a metadata file, and
an HTML report to the deployment directory.

- `Auto_QC_<deployment>.csv` is a permanent record of this state of the
  process and should not be edited.
- `Preliminary_QC_<deployment>.csv` is for subsequent review and
  editing. `Preliminary_` should be dropped from the name when review is
  complete.
- `Metadata_<deployment>.yml` contains the metadata written as a YAML
  file.
- `QC_<deployment>_report.html` contains plots and summary information
  about the deployment. It is a very large file so should be deleted
  after the QC is complete. It can be recreated later with
  `make_deployment_report(deployment_dir)` as long as the Auto QC and
  metadata files are present.

#### Tabular data

Here are a few lines of the data written to the two CSV files when using
`setup_example_dir()`.

| Site | Date       | Date_Time           | Gen_QC | Flags | Time     | Time_QC | Temp_DOLog | Temp_DOLog_QC | Temp_CondLog | Temp_CondLog_QC | Raw_DO | Raw_DO_QC |   DO | DO_QC | DO_Calibration_QC | DO_Pct_Sat | DO_Pct_Sat_QC | Salinity | Salinity_QC | Sal_Calibration_QC | High_Range | High_Range_QC | Spec_Cond | Spec_Cond_QC | Cal | QA_Comment | Field_Comment |
|:-----|:-----------|:--------------------|-------:|:------|:---------|:--------|-----------:|:--------------|-------------:|:----------------|-------:|:----------|-----:|:------|:------------------|-----------:|:--------------|---------:|:------------|:-------------------|-----------:|:--------------|----------:|:-------------|----:|:-----------|:--------------|
| RB1  | 2023-06-02 | 2023-06-02 17:50:00 |        |       | 17:50:00 |         |      21.32 |               |        22.29 |                 |   7.33 |           | 6.33 |       |                   |       84.8 |               |  29.2351 |             |                    |    30864.7 |               |   45190.4 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 18:00:00 |        |       | 18:00:00 |         |      21.30 |               |        22.32 |                 |   7.53 |           | 6.51 |       |                   |       87.1 |               |  29.1925 |             |                    |    30844.4 |               |   45131.4 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 18:10:00 |        |       | 18:10:00 |         |      21.36 |               |        22.38 |                 |   7.66 |           | 6.62 |       |                   |       88.7 |               |  29.1753 |             |                    |    30867.3 |               |   45107.6 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 18:20:00 |        |       | 18:20:00 |         |      21.32 |               |        22.29 |                 |   7.75 |           | 6.70 |       |                   |       89.7 |               |  29.2189 |             |                    |    30852.0 |               |   45168.0 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 18:30:00 |        |       | 18:30:00 |         |      21.32 |               |        22.32 |                 |   7.70 |           | 6.65 |       |                   |       89.1 |               |  29.2059 |             |                    |    30859.7 |               |   45149.9 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 18:40:00 |        |       | 18:40:00 |         |      21.38 |               |        22.39 |                 |   7.75 |           | 6.70 |       |                   |       89.8 |               |  29.1873 |             |                    |    30887.7 |               |   45124.3 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 18:50:00 |        |       | 18:50:00 |         |      21.42 |               |        22.46 |                 |   7.82 |           | 6.76 |       |                   |       90.6 |               |  29.1716 |             |                    |    30918.3 |               |   45102.4 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 19:00:00 |        |       | 19:00:00 |         |      21.44 |               |        22.46 |                 |   7.82 |           | 6.76 |       |                   |       90.7 |               |  29.1868 |             |                    |    30933.6 |               |   45123.5 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 19:10:00 |        |       | 19:10:00 |         |      21.40 |               |        22.42 |                 |   7.71 |           | 6.66 |       |                   |       89.3 |               |  29.1832 |             |                    |    30905.5 |               |   45118.5 |              |     |            |               |
| RB1  | 2023-06-02 | 2023-06-02 19:20:00 |        |       | 19:20:00 |         |      21.48 |               |        22.55 |                 |   7.98 |           | 6.90 |       |                   |       92.6 |               |  29.1648 |             |                    |    30971.9 |               |   45093.0 |              |     |            |               |

#### Metadata

This is the metadata derived from the example.

- site: RB1
- deployment: RB1_2023-06-09
- deployment_date: 2023-06-09
- calibration_start: 2023-06-02 11:10:00
- calibration_end: 2023-06-09 12:40:00
- pct_calibrated: 99.3171
- n_records: 1018
- pct_immediate_rejection: 0
- pct_flagged_for_review: 3.54
- logging_interval_min: 10
- timezone: GMT-04:00
- auto_qc_date: 2024-05-21
- do_calibration:
  - start_do_conc: 7.37
  - start_temperature_c: 22
  - start_salinity_ppt: 28.47
  - start_meter_titration_value_mg_l: 6.41
  - start_salinity_correction: 0.8475
  - end_do_conc: 9.12
  - end_temperature_c: 18.1
  - end_meter_titration_value_mg_l: 7.62
  - start_ratio: 0.869742198100407
  - end_ratio: 0.835526315789474
- do_deployment:
  - full_series_name: DO Adj Conc , mg/L
  - launch_name: BBC3_RB1_20659182
  - launch_time: 2023-06-01 14:16:43
  - calibration_date: 2023-05-16 17:04:40
  - calibration_gain: 1.07718
  - calibration_offset: -0.02045
- do_device:
  - product: HOBO U26-001 Dissolved Oxygen
  - serial_number: 20659182
  - version_number: 1.08
  - header_created: 2012-03-02 14:19:05
- cond_calibration:
  - start_cal_cond: 40768
  - start_cal_temp: 21.1
  - end_cal_cond: 39200
  - end_cal_temp: 17.8
- cond_deployment:
  - full_series_name: Salinity, ppt
  - launch_name: BBC3_RB1_20636185
  - launch_time: 2023-06-01 14:41:47
- cond_device:
  - product: HOBO U24-002 Conductivity
  - serial_number: 20636185
  - version_number: 1.52
  - header_created: 2019-06-10 08:05:37
