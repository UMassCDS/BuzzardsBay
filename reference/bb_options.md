# Set and retrieve BuzzardsBay package options

With no arguments all the Buzzards Bay parameters will be returned as a
list. Use a single character value to retrieve the value of a single
option. Use one or more named arguments to set options.

## Usage

``` r
bb_options(...)
```

## Arguments

- ...:

  One of:

  1.  one or more named arguments where the name is a an option and the
      value its new setting e.g. `sal_max_jump = 0.75`;

  2.  a single unnamed argument stating an option to retrieve e.g.
      `"sal_max_jump"`.

  3.  No arguments, indicating that all options and their current
      settings should be returned in a list; or

  4.  a single list argument with named items and their new values.

## Value

If no arguments are used than all options will be returned as a list. If
there is a single, unnamed argument with a character value indicating an
option than the value of that option will be returned. Otherwise, the
arguments should indicate new option settings and nothing will be
returned.

## Details

The options:

- `do_lv_duration`, `do_lv_range`:

  For Low Variation in Dissolved Oxygen (`Dlv`) flag. `do_lv_range` is
  the maximum difference between the maximum and the minimum values in a
  streak longer than `do_lv_duration` minutes before the the low
  variation in dissolved oxygen (`Dlv`) flag is set

- `do_max_jump`:

  The maximum difference between consecutive DO readings before the jump
  in dissolved oxygen (`Dj`) flag is is set.

- `do_streak_duration`, `do_streak_min`:

  If DO remains below `do_streak_min` for more than `do_streak_duration`
  than the Dissolved Oxygen low streak (`Dls`) flag is set.

- `logger_error_values`:

  One or more values that indicate a logger error. If setting multiple
  values in a YAML file use indented lines with a dash for each value:

      logger_error_values:
        - -888.88
        - 9999

  Temperature (from both loggers), High Range, and Raw DO are all
  checked for this value. Flags: `TDe`, `TCe`, `He`, and `Re`.

- `max_hr`, `min_hr`:

  Thresholds for the high high range (`Hh`) and low high range (`Hl`)
  flags.

- `max_raw_do`:

  Threshold for the high raw DO (`Rh`) flag.

- `max_temp`, `min_temp`:

  Thresholds for the high temperature (`TDh`, `TCh`) and low temperature
  (`TDl`, `TCl`)

- `plot_min_do`, `plot_max_do`, `plot_min_sal`, `plot_max_sal`,
  `plot_min_temp`, `plot_max_temp`:

  These constrain the Y range in the QC Report plots when plotting
  Dissolved Oxygen (`DO`), Salinity (`sal`), and temperature (`temp`)

- `sal_lv_duration`, `sal_lv_range`:

  If the difference between the maximum and minimum salinity remains
  below `sal_lc_range` for more than `sal_lv_duration` minutes than the
  low variation in salinity (`Slv`) flag is set.

- `sal_max_jump`:

  The maximum difference between successive salinity records before the
  salinity jump (`Sj`) flag is set for both involved records.

- `min_depth`, `max_depth`:

  The minimum and maximum water depth. If the `Depth` column is present
  and falls outside of this range either the `Wl` (water depth low) or
  `Wh` (water depth high) flags will be thrown. Additionally `7` will be
  written to `Depth_QC` and either `9999` or `7` will be written to
  `Gen_QC` depending on if it's high or low respectively

## Examples

``` r
 o <- bb_options()
 cat(yaml::as.yaml(o))
#> do_lv_duration: 60.0
#> do_lv_range: 0.01
#> do_max_jump: 2.0
#> do_streak_duration: 60.0
#> do_streak_min: 0.5
#> logger_error_values: -888.88
#> max_depth: 9.0
#> max_hr: 55000.0
#> max_raw_do: 20.0
#> max_temp: 35.0
#> min_depth: 0.0
#> min_hr: 1000.0
#> min_temp: 5.0
#> plot_max_do: 20.0
#> plot_max_sal: 36.0
#> plot_max_temp: 31.0
#> plot_min_do: -0.5
#> plot_min_sal: 0.0
#> plot_min_temp: 0.0
#> sal_lv_duration: 60.0
#> sal_lv_range: 0.01
#> sal_max_jump: 0.75
 bb_options(sal_max_jump = 0.5)
 bb_options("sal_max_jump")
#> [1] 0.5
 bb_options(o)  # Reset original options
 bb_options("sal_max_jump")
#> [1] 0.75
```
