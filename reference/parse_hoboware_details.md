# Read HOBOware details file

Read a HOBOware details file and parse into a nested list.

## Usage

``` r
parse_hoboware_details(path)
```

## Arguments

- path:

  The path to a HOBOware details file created while calibrating.

## Value

A nested list with the file contents.

## Details

The HOBOware details file contains data on the sensor, the deployment,
and the calibration process. Indentation level is used to indicate the
hierarchy in the data. `parse_hoboware_details()` parses the file into a
list that captures that structure.

The approach taken is a little bit of kludge but seems to be working for
the files produced by the DO and Conductivity loggers.
`parse_hoboware_details()` first edits the details text so that it can
be parsed as [YAML](https://en.wikipedia.org/wiki/YAML) into an R nested
list. The resulting list is then cleaned by eliminating spaces and weird
characters from the list item names (but not values) and dropping some
redundant nesting.

## Note

The sample numbers in the details files include commas (e.g 1,283 ) that
trip up the YAML conversion. These are eliminated in a targeted
fashion - dropping commas between digits only on lines with `"Max:"`,
`"Min:"`, `"Avg:"`, `"Std Dev:"` or `"Samples:"`. With other output
files this might need to be expanded to cover more of the file, but
given that commas could potential delineate items in a list a surgical
approach was used.

With conductivity details files some of the values are separated from
the field names with "=" instead of ":", used in most of the file. To
process these items correctly all " = " are replaced with ": " before
parsing as YAML. This might create unintended consequences in some
fields or with other HOBOware output, but it does not adversely affect
any of the fields extracted by this package, in
[`get_do_details()`](https://umasscds.github.io/BuzzardsBay/reference/get_do_details.md)
or
[`get_cond_details()`](https://umasscds.github.io/BuzzardsBay/reference/get_cond_details.md).

`parse_hoboware_details()` is primarily intended for internal package
use

## Examples

``` r
 file <- system.file(
   "extdata/2023/RB1/2023-06-09/Calibrated/DO_RB1_2023-06-09_Details.txt",
                     package = "BuzzardsBay")
 hwd <- parse_hoboware_details(file)
 str(hwd, max.level = 2)
#> List of 8
#>  $ Series_DO_conc_mg_per_L    :List of 3
#>   ..$ Devices          :List of 1
#>   ..$ Deployment_Info  :List of 11
#>   ..$ Series_Statistics:List of 7
#>  $ Series_Temp_C              :List of 3
#>   ..$ Devices          :List of 1
#>   ..$ Deployment_Info  :List of 8
#>   ..$ Series_Statistics:List of 7
#>  $ Series_DO_Adj_Conc_mg_per_L:List of 4
#>   ..$ Devices                              :List of 1
#>   ..$ Deployment_Info                      :List of 11
#>   ..$ Series_Statistics                    :List of 7
#>   ..$ Dissolved_Oxygen_Assistant_Parameters:List of 24
#>  $ Series_DO_Percent_pct      :List of 4
#>   ..$ Devices                              :List of 1
#>   ..$ Deployment_Info                      :List of 11
#>   ..$ Series_Statistics                    :List of 7
#>   ..$ Dissolved_Oxygen_Assistant_Parameters:List of 24
#>  $ Series_Salinity_ppt        :List of 3
#>   ..$ Devices          :List of 1
#>   ..$ Deployment_Info  :List of 8
#>   ..$ Series_Statistics:List of 7
#>  $ Event_Type_Coupler_Attached:List of 3
#>   ..$ Devices          :List of 1
#>   ..$ Deployment_Info  :List of 6
#>   ..$ Series_Statistics:List of 3
#>  $ Event_Type_Stopped         :List of 3
#>   ..$ Devices          :List of 1
#>   ..$ Deployment_Info  :List of 6
#>   ..$ Series_Statistics:List of 3
#>  $ Event_Type_End_Of_File     :List of 3
#>   ..$ Devices          :List of 1
#>   ..$ Deployment_Info  :List of 6
#>   ..$ Series_Statistics:List of 3

 # These are of particular interest
 hwd$Series_DO_Adj_Conc_mg_per_L$Dissolved_Oxygen_Assistant_Parameters |>
   yaml::as.yaml() |>
   cat()
#> Performing_Field_Calibration: .na
#> Using_start_cal_point: .na
#> Start_time: 06/02/23 11:10:00 AM GMT-04:00
#> Start_DO_conc: 7.37
#> Start_temperature_C: 22.0
#> Start_salinity_ppt: 28.47
#> Start_meter_per_titration_value_mg_per_L: 6.41
#> Start_salinity_correction: 0.8475
#> Using_end_cal_point: .na
#> End_time: 06/09/23 12:40:00 PM GMT-04:00
#> End_DO_conc: 9.12
#> End_temperature_C: 18.1
#> End_salinity_ppt: 28.47
#> End_meter_per_titration_value_mg_per_L: 7.62
#> End_salinity_correction: 0.8382
#> Adjust_for_Salinity_selected: .na
#> Salinity_datafile: Y:\BAYWATCHERS\HOBO dataloggers\RB1\Deployments_RBH\2023\6_9_2023\Calibrated
#>   Data\RB1_SpecCon_6_9_2023_AH.txt
#> Overlap_mode: Option 1
#> Barometric_Pressure_selected: .na
#> Pressure_value_atm: 1.0
#> Elevation_m: 0.0
#> Reporting_data_between_selected_points_only: .na
#> Start: Field cal reference start
#> End: Field cal reference end
```
