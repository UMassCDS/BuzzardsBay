# Package index

## Quality Control Module

Run automated QC and support interactive QC on individual deployments

- [`qc_deployment()`](https://umasscds.github.io/BuzzardsBay/reference/qc_deployment.md)
  : Run automatic quality control on a deployment
- [`make_deployment_report()`](https://umasscds.github.io/BuzzardsBay/reference/make_deployment_report.md)
  : Make QAQC report for a deployment

## Analysis Module

Stitch and report on all the deployments at a site

- [`report_site()`](https://umasscds.github.io/BuzzardsBay/reference/report_site.md)
  : Produce stats and a report for a site and year

- [`check_site()`](https://umasscds.github.io/BuzzardsBay/reference/check_site.md)
  :

  Check to be sure that result files from `stitch_site` are up to date

- [`stitch_site()`](https://umasscds.github.io/BuzzardsBay/reference/stitch_site.md)
  : Stitch all deployments for a site and year

## Secondary functions

Secondary functions that are primarily used internally but might be
useful to users

- [`bb_options()`](https://umasscds.github.io/BuzzardsBay/reference/bb_options.md)
  : Set and retrieve BuzzardsBay package options

- [`bb_plot()`](https://umasscds.github.io/BuzzardsBay/reference/bb_plot.md)
  : Make static plot of logger data

- [`create_parameter_file()`](https://umasscds.github.io/BuzzardsBay/reference/create_parameter_file.md)
  : Create a BuzzardsBay parameter file

- [`extract_baywatchers()`](https://umasscds.github.io/BuzzardsBay/reference/extract_baywatchers.md)
  : Extract relevant Baywatchers data from ginormous Excel file

- [`get_tide_height()`](https://umasscds.github.io/BuzzardsBay/reference/get_tide_height.md)
  :

  Get the tide height at a particular station corresponding to a series
  of date, times. Note due to limitations in the **rtide** package this
  only works for about a third of the Buzzards Bay NOAA tide stations.

- [`import_calibrated_data()`](https://umasscds.github.io/BuzzardsBay/reference/import_calibrated_data.md)
  : Import Calibrated Deployment Data

- [`is_daylight()`](https://umasscds.github.io/BuzzardsBay/reference/is_daylight.md)
  : Determine if observation correspond to daylight hours or not

- [`lookup_paths()`](https://umasscds.github.io/BuzzardsBay/reference/lookup_paths.md)
  : Lookup paths for data and parameter files

- [`plot_tide_sun()`](https://umasscds.github.io/BuzzardsBay/reference/plot_tide_sun.md)
  : Plot tide height and daylight hours

- [`tide_station_info`](https://umasscds.github.io/BuzzardsBay/reference/tide_station_info.md)
  : Locations of NOAA tide stations within Buzzards Bay

- [`setup_example_dir()`](https://umasscds.github.io/BuzzardsBay/reference/setup_example_dir.md)
  : Set up an example directory

## Internal functions

Internal functions, not intended for package users

- [`aggreg()`](https://umasscds.github.io/BuzzardsBay/reference/aggreg.md)
  : Improved version of aggregate

- [`apply_timezone()`](https://umasscds.github.io/BuzzardsBay/reference/apply_timezone.md)
  : Apply at timezone to a date time string or object

- [`bb_interactive_plot()`](https://umasscds.github.io/BuzzardsBay/reference/bb_interactive_plot.md)
  : Interactive logger data plot

- [`check_placement()`](https://umasscds.github.io/BuzzardsBay/reference/check_placement.md)
  : Check SN, site, deployment date, and logger type against placements
  table

- [`clean_csv_import_names()`](https://umasscds.github.io/BuzzardsBay/reference/clean_csv_import_names.md)
  : Clean up column names for basic CSV input

- [`combine_flags()`](https://umasscds.github.io/BuzzardsBay/reference/combine_flags.md)
  : Combine the flags from individual "\_Flags" columns into a single
  flags vector.

- [`cut_path_items()`](https://umasscds.github.io/BuzzardsBay/reference/cut_path_items.md)
  : cut items off the end of a path

- [`daily_stats()`](https://umasscds.github.io/BuzzardsBay/reference/daily_stats.md)
  : Produce daily stats for a site

- [`format_csv_date()`](https://umasscds.github.io/BuzzardsBay/reference/format_csv_date.md)
  : Format CSV date that might have been corrupted by excel

- [`format_csv_date_time()`](https://umasscds.github.io/BuzzardsBay/reference/format_csv_date_time.md)
  : Format CSV date time that might have been corrupted by excel

- [`format_date_time()`](https://umasscds.github.io/BuzzardsBay/reference/format_date_time.md)
  : Internal function to reformat the date time date from Details.txt

- [`get_cond_details()`](https://umasscds.github.io/BuzzardsBay/reference/get_cond_details.md)
  : Retrieve information from a conductivity calibration details file

- [`get_do_details()`](https://umasscds.github.io/BuzzardsBay/reference/get_do_details.md)
  : Retrieve information stored a Dissolved Oxygen calibration details
  file

- [`get_expected_columns()`](https://umasscds.github.io/BuzzardsBay/reference/get_expected_columns.md)
  : Look up expected column names and order

- [`get_file_hashes()`](https://umasscds.github.io/BuzzardsBay/reference/get_file_hashes.md)
  : Get md5 hashes for a vector of files

- [`get_site_name()`](https://umasscds.github.io/BuzzardsBay/reference/get_site_name.md)
  : Get the full site name for a site

- [`import_tide_rider()`](https://umasscds.github.io/BuzzardsBay/reference/import_tide_rider.md)
  : Import Tide Rider Data

- [`longest_duration()`](https://umasscds.github.io/BuzzardsBay/reference/longest_duration.md)
  : Give duration of the longest run of low DO for each day

- [`lookup_devices()`](https://umasscds.github.io/BuzzardsBay/reference/lookup_devices.md)
  : Lookup the DO and conductivity logger device models

- [`lookup_site_paths()`](https://umasscds.github.io/BuzzardsBay/reference/lookup_site_paths.md)
  : Look up paths for a specified site

- [`make_facet_plot()`](https://umasscds.github.io/BuzzardsBay/reference/make_facet_plot.md)
  : Produce a paired time series plot of DO and Temperature for the
  final report

- [`make_plot()`](https://umasscds.github.io/BuzzardsBay/reference/make_plot.md)
  : Produce a time series plot for the final report

- [`make_plot_2var()`](https://umasscds.github.io/BuzzardsBay/reference/make_plot_2var.md)
  : Produce a time series plot with two datasets for the final report

- [`mean_daily_durations()`](https://umasscds.github.io/BuzzardsBay/reference/mean_daily_durations.md)
  : Give mean duration of low-DO runs in hours

- [`parse_hoboware_details()`](https://umasscds.github.io/BuzzardsBay/reference/parse_hoboware_details.md)
  : Read HOBOware details file

- [`parse_mx801_details()`](https://umasscds.github.io/BuzzardsBay/reference/parse_mx801_details.md)
  : Extract specific metadata items from the MX801 details sheet

- [`read_and_format_placements()`](https://umasscds.github.io/BuzzardsBay/reference/read_and_format_placements.md)
  : Read and format placements

- [`read_deployment_yaml()`](https://umasscds.github.io/BuzzardsBay/reference/read_deployment_yaml.md)
  : Read deployment metadata from a YAML file

- [`read_mx801_data()`](https://umasscds.github.io/BuzzardsBay/reference/read_mx801_data.md)
  : Import data from MX801 logger

- [`replace_na_runs()`](https://umasscds.github.io/BuzzardsBay/reference/replace_na_runs.md)
  : Replace short runs of NA in logical vector

- [`rle2()`](https://umasscds.github.io/BuzzardsBay/reference/rle2.md) :

  A drop-in replacement for
  [`base::rle()`](https://rdrr.io/r/base/rle.html) that treats all NAs
  as identical

- [`seasonal_stats()`](https://umasscds.github.io/BuzzardsBay/reference/seasonal_stats.md)
  : Produce seasonal stats for a site

- [`suppress_specific_warnings()`](https://umasscds.github.io/BuzzardsBay/reference/suppress_specific_warnings.md)
  : Suppress some specific warnings

- [`update_bb_parameters()`](https://umasscds.github.io/BuzzardsBay/reference/update_bb_parameters.md)
  : Update Buzzards Bay parameters
