# stitching works

    Code
      stitch_site(site_dir)
    Output
      Note: gap between deployments 2024-08-16 and 2024-09-05 is 1087800s (~1.8 weeks)
      
      Site AB2 processed for 2024. There were 2 deployments and a total of 3,312 rows.
      Results are in BB_Data/2024/AB2/

---

    Code
      read.csv(file.path(site_dir, "combined", "WPP_AB2_2024.csv"), nrows = 40)
    Output
                 Waterbody Site Latitude Longitude Depth Depth_QC
      1  Apponagansett Bay  AB2       NA        NA    DR       NA
      2  Apponagansett Bay  AB2       NA        NA             NA
      3  Apponagansett Bay  AB2       NA        NA             NA
      4  Apponagansett Bay  AB2       NA        NA             NA
      5  Apponagansett Bay  AB2       NA        NA             NA
      6  Apponagansett Bay  AB2       NA        NA             NA
      7  Apponagansett Bay  AB2       NA        NA             NA
      8  Apponagansett Bay  AB2       NA        NA             NA
      9  Apponagansett Bay  AB2       NA        NA             NA
      10 Apponagansett Bay  AB2       NA        NA    DR       NA
      11 Apponagansett Bay  AB2       NA        NA             NA
      12 Apponagansett Bay  AB2       NA        NA             NA
      13 Apponagansett Bay  AB2       NA        NA    DR       NA
      14 Apponagansett Bay  AB2       NA        NA    DR       NA
      15 Apponagansett Bay  AB2       NA        NA    DR       NA
      16 Apponagansett Bay  AB2       NA        NA    DR       NA
      17 Apponagansett Bay  AB2       NA        NA             NA
      18 Apponagansett Bay  AB2       NA        NA             NA
      19 Apponagansett Bay  AB2       NA        NA             NA
      20 Apponagansett Bay  AB2       NA        NA             NA
      21 Apponagansett Bay  AB2       NA        NA             NA
      22 Apponagansett Bay  AB2       NA        NA             NA
      23 Apponagansett Bay  AB2       NA        NA             NA
      24 Apponagansett Bay  AB2       NA        NA             NA
      25 Apponagansett Bay  AB2       NA        NA             NA
      26 Apponagansett Bay  AB2       NA        NA             NA
      27 Apponagansett Bay  AB2       NA        NA             NA
      28 Apponagansett Bay  AB2       NA        NA             NA
      29 Apponagansett Bay  AB2       NA        NA             NA
      30 Apponagansett Bay  AB2       NA        NA             NA
      31 Apponagansett Bay  AB2       NA        NA             NA
      32 Apponagansett Bay  AB2       NA        NA             NA
      33 Apponagansett Bay  AB2       NA        NA             NA
      34 Apponagansett Bay  AB2       NA        NA             NA
      35 Apponagansett Bay  AB2       NA        NA             NA
      36 Apponagansett Bay  AB2       NA        NA             NA
      37 Apponagansett Bay  AB2       NA        NA             NA
      38 Apponagansett Bay  AB2       NA        NA             NA
      39 Apponagansett Bay  AB2       NA        NA             NA
      40 Apponagansett Bay  AB2       NA        NA             NA
                       Unique_ID       Date           Date_Time Julian_Date Gen_QC
      1  AB2_2024-08-06_14:40:00 2024-08-06 2024-08-06 14:40:00         219     NA
      2  AB2_2024-08-06_14:50:00 2024-08-06 2024-08-06 14:50:00         219     12
      3  AB2_2024-08-06_15:00:00 2024-08-06 2024-08-06 15:00:00         219     NA
      4  AB2_2024-08-06_15:10:00 2024-08-06 2024-08-06 15:10:00         219     NA
      5  AB2_2024-08-06_15:20:00 2024-08-06 2024-08-06 15:20:00         219     NA
      6  AB2_2024-08-06_15:30:00 2024-08-06 2024-08-06 15:30:00         219     NA
      7  AB2_2024-08-06_15:40:00 2024-08-06 2024-08-06 15:40:00         219     NA
      8  AB2_2024-08-06_15:50:00 2024-08-06 2024-08-06 15:50:00         219     NA
      9  AB2_2024-08-06_16:00:00 2024-08-06 2024-08-06 16:00:00         219     NA
      10 AB2_2024-08-06_16:10:00 2024-08-06 2024-08-06 16:10:00         219      1
      11 AB2_2024-08-06_16:20:00 2024-08-06 2024-08-06 16:20:00         219      3
      12 AB2_2024-08-06_16:30:00 2024-08-06 2024-08-06 16:30:00         219      4
      13 AB2_2024-08-06_16:40:00 2024-08-06 2024-08-06 16:40:00         219      7
      14 AB2_2024-08-06_16:50:00 2024-08-06 2024-08-06 16:50:00         219      9
      15 AB2_2024-08-06_17:00:00 2024-08-06 2024-08-06 17:00:00         219     90
      16 AB2_2024-08-06_17:10:00 2024-08-06 2024-08-06 17:10:00         219     91
      17 AB2_2024-08-06_17:20:00 2024-08-06 2024-08-06 17:20:00         219     11
      18 AB2_2024-08-06_17:30:00 2024-08-06 2024-08-06 17:30:00         219     12
      19 AB2_2024-08-06_17:40:00 2024-08-06 2024-08-06 17:40:00         219     13
      20 AB2_2024-08-06_17:50:00 2024-08-06 2024-08-06 17:50:00         219     14
      21 AB2_2024-08-06_18:00:00 2024-08-06 2024-08-06 18:00:00         219     NA
      22 AB2_2024-08-06_18:10:00 2024-08-06 2024-08-06 18:10:00         219     NA
      23 AB2_2024-08-06_18:20:00 2024-08-06 2024-08-06 18:20:00         219     NA
      24 AB2_2024-08-06_18:30:00 2024-08-06 2024-08-06 18:30:00         219     NA
      25 AB2_2024-08-06_18:40:00 2024-08-06 2024-08-06 18:40:00         219     NA
      26 AB2_2024-08-06_18:50:00 2024-08-06 2024-08-06 18:50:00         219     NA
      27 AB2_2024-08-06_19:00:00 2024-08-06 2024-08-06 19:00:00         219     NA
      28 AB2_2024-08-06_19:10:00 2024-08-06 2024-08-06 19:10:00         219     NA
      29 AB2_2024-08-06_19:20:00 2024-08-06 2024-08-06 19:20:00         219     NA
      30 AB2_2024-08-06_19:30:00 2024-08-06 2024-08-06 19:30:00         219     NA
      31 AB2_2024-08-06_19:40:00 2024-08-06 2024-08-06 19:40:00         219     NA
      32 AB2_2024-08-06_19:50:00 2024-08-06 2024-08-06 19:50:00         219     NA
      33 AB2_2024-08-06_20:00:00 2024-08-06 2024-08-06 20:00:00         219     NA
      34 AB2_2024-08-06_20:10:00 2024-08-06 2024-08-06 20:10:00         219     NA
      35 AB2_2024-08-06_20:20:00 2024-08-06 2024-08-06 20:20:00         219     NA
      36 AB2_2024-08-06_20:30:00 2024-08-06 2024-08-06 20:30:00         219     NA
      37 AB2_2024-08-06_20:40:00 2024-08-06 2024-08-06 20:40:00         219     NA
      38 AB2_2024-08-06_20:50:00 2024-08-06 2024-08-06 20:50:00         219     NA
      39 AB2_2024-08-06_21:00:00 2024-08-06 2024-08-06 21:00:00         219     NA
      40 AB2_2024-08-06_21:10:00 2024-08-06 2024-08-06 21:10:00         219     NA
         Flags     Time Time_QC Temp_DOLog Temp_DOLog_QC Temp_CondLog Temp_CondLog_QC
      1     NA 14:40:00      NA         DR            NA           DR              NA
      2     NA 14:50:00      NA      24.92            NA        25.72              NA
      3     NA 15:00:00      NA      25.06            NA        25.82              NA
      4     NA 15:10:00      NA      24.98            NA        25.71              NA
      5     NA 15:20:00      NA      24.94            NA        25.67              NA
      6     NA 15:30:00      NA       24.9            NA        25.64              NA
      7     NA 15:40:00      NA      24.94            NA        25.74              NA
      8     NA 15:50:00      NA      25.04            NA        25.84              NA
      9     NA 16:00:00      NA       25.1            NA         25.9              NA
      10    NA 16:10:00      NA         DR            NA           DR              NA
      11    NA 16:20:00      NA      25.14            NA        25.87              NA
      12    NA 16:30:00      NA      25.12            NA        25.84              NA
      13    NA 16:40:00      NA         DR            NA           DR              NA
      14    NA 16:50:00      NA         DR            NA           DR              NA
      15    NA 17:00:00      NA         DR            NA           DR              NA
      16    NA 17:10:00      NA         DR            NA           DR              NA
      17    NA 17:20:00      NA      24.58            NA        25.23              NA
      18    NA 17:30:00      NA      24.44            NA        25.15              NA
      19    NA 17:40:00      NA      24.42            NA        25.08              NA
      20    NA 17:50:00      NA      24.28            NA        24.98              NA
      21    NA 18:00:00      NA      24.22            NA         24.9              NA
      22    NA 18:10:00      NA      24.08            NA        24.75              NA
      23    NA 18:20:00      NA      23.98            NA         24.7              NA
      24    NA 18:30:00      NA      23.96            NA         24.7              NA
      25    NA 18:40:00      NA      23.94            NA        24.67              NA
      26    NA 18:50:00      NA      23.94            NA        24.68              NA
      27    NA 19:00:00      NA      23.96            NA         24.7              NA
      28    NA 19:10:00      NA      23.98            NA        24.73              NA
      29    NA 19:20:00      NA         24            NA        24.75              NA
      30    NA 19:30:00      NA         24            NA        24.73              NA
      31    NA 19:40:00      NA         24            NA        24.73              NA
      32    NA 19:50:00      NA      24.02            NA        24.83              NA
      33    NA 20:00:00      NA      24.18            NA        24.98              NA
      34    NA 20:10:00      NA       24.2            NA        24.94              NA
      35    NA 20:20:00      NA       24.2            NA        24.94              NA
      36    NA 20:30:00      NA      24.24            NA        24.98              NA
      37    NA 20:40:00      NA      24.24            NA        24.98              NA
      38    NA 20:50:00      NA      24.24            NA        24.97              NA
      39    NA 21:00:00      NA      24.22            NA        24.92              NA
      40    NA 21:10:00      NA      24.24            NA        25.02              NA
         Raw_DO Raw_DO_QC   DO DO_QC DO_Calibration_QC DO_Pct_Sat DO_Pct_Sat_QC
      1      DR        NA   DR    NA                NA         DR            NA
      2    6.71        NA 5.41    NA                NA       77.9            NA
      3    6.57        NA  5.3    NA                NA       76.5            NA
      4    6.41        NA 5.17    NA                NA       74.5            NA
      5    6.59        NA 5.31    NA                NA       76.6            NA
      6    6.73        NA 5.42    NA                NA       78.2            NA
      7    7.24        NA 5.83    NA                NA       84.1            NA
      8    7.14        NA 5.76    NA                NA       83.1            NA
      9    6.91        NA 5.57    NA                NA       80.5            NA
      10     DR        NA   DR    NA                NA         DR            NA
      11   6.98        NA 5.63    NA                NA       81.4            NA
      12   6.94        NA 5.59    NA                NA       80.9            NA
      13     DR        NA   DR    NA                NA         DR            NA
      14     DR        NA   DR    NA                NA         DR            NA
      15     DR        NA   DR    NA                NA         DR            NA
      16     DR        NA   DR    NA                NA         DR            NA
      17    6.4        NA 5.15    NA                NA       73.9            NA
      18   6.42        NA 5.16    NA                NA       73.9            NA
      19   6.44        NA 5.17    NA                NA       74.2            NA
      20   6.34        NA 5.09    NA                NA       72.8            NA
      21   6.61        NA 5.31    NA                NA       75.8            NA
      22   6.72        NA 5.39    NA                NA       76.9            NA
      23   6.78        NA 5.44    NA                NA       77.4            NA
      24   6.72        NA 5.39    NA                NA       76.7            NA
      25    6.6        NA 5.29    NA                NA       75.3            NA
      26   6.52        NA 5.23    NA                NA       74.4            NA
      27   6.51        NA 5.22    NA                NA       74.3            NA
      28   6.52        NA 5.23    NA                NA       74.5            NA
      29   6.47        NA 5.19    NA                NA       73.9            NA
      30     DR         1 5.15    NA                NA       73.4            NA
      31   6.57         3 5.27    NA                NA       75.1            NA
      32   6.65         4 5.34    NA                NA         76            NA
      33     DR         7 5.53    NA                NA         79            NA
      34     DR         9 5.48    NA                NA       78.4            NA
      35     DR        90  5.4    NA                NA       77.1            NA
      36     DR        91 5.36    NA                NA       76.6            NA
      37   6.57        11 5.28    NA                NA       75.4            NA
      38    6.7        12 5.38    NA                NA       76.9            NA
      39    6.4        13 5.14    NA                NA       73.5            NA
      40   6.47        14  5.2    NA                NA       74.3            NA
         Salinity Salinity_QC Sal_Calibration_QC High_Range High_Range_QC Spec_Cond
      1        DR          NA                 NA         DR            NA        DR
      2   30.9357          NA                 NA    25556.3            NA   47535.9
      3   30.9029          NA                 NA    25583.4            NA   47490.7
      4   30.9885          NA                 NA    25591.9            NA   47608.3
      5   31.0471          NA                 NA    25615.7            NA   47688.8
      6   31.0872          NA                 NA    25630.9            NA   47743.8
      7   31.0311          NA                 NA    25641.1            NA   47666.8
      8   30.9843          NA                 NA    25658.1            NA   47602.7
      9   30.9467          NA                 NA    25661.5            NA     47551
      10       DR          NA                 NA         DR            NA        DR
      11   30.988          NA                 NA    25678.6            NA   47607.7
      12   31.035          NA                 NA      25699            NA   47672.2
      13       DR          NA                 NA         DR            NA        DR
      14       DR          NA                 NA         DR            NA        DR
      15       DR          NA                 NA         DR            NA        DR
      16       DR          NA                 NA         DR            NA        DR
      17  31.3728          NA                 NA    25641.1            NA   48135.6
      18  31.4347          NA                 NA    25646.2            NA   48220.3
      19  31.4686          NA                 NA      25636            NA   48266.9
      20  31.5146          NA                 NA    25619.1            NA   48329.9
      21  31.5909          NA                 NA    25634.3            NA   48434.4
      22  31.6587          NA                 NA    25607.2            NA   48527.1
      23   31.733          NA                 NA      25636            NA   48628.8
      24  31.7341          NA                 NA    25637.7            NA   48630.4
      25  31.7638          NA                 NA    25644.5            NA     48671
      26  31.7531          NA                 NA    25642.8            NA   48656.3
      27    31.74          NA                 NA    25644.5            NA   48638.4
      28  31.7339          NA                 NA    25656.4            NA   48630.1
      29  31.7255          NA                 NA    25661.5            NA   48618.6
      30  31.6775          NA                 NA    25617.4            NA   48552.9
      31  31.7256          NA                 NA      25653            NA   48618.7
      32  31.6744          NA                 NA    25668.3            NA   48548.7
      33  31.6046          NA                 NA    25695.6            NA   48453.1
      34   31.627          NA                 NA    25692.2            NA   48483.8
      35  31.4947          NA                 NA      25597            NA   48302.5
      36  31.5634          NA                 NA    25668.3            NA   48396.7
      37  31.5669          NA                 NA    25671.7            NA   48401.5
      38  31.5634          NA                 NA    25664.9            NA   48396.8
      39  31.5859          NA                 NA    25656.4            NA   48427.5
      40  31.4907          NA                 NA    25639.4            NA   48297.2
         Spec_Cond_QC Cal QA_Comment Field_Comment Exclude Deployment
      1            NA   1         NA            NA      NA         NA
      2            NA  NA         NA            NA      NA          1
      3            NA  NA         NA            NA      NA         NA
      4            NA  NA         NA            NA      NA         NA
      5            NA  NA         NA            NA      NA         NA
      6            NA  NA         NA            NA      NA         NA
      7            NA  NA         NA            NA      NA         NA
      8            NA  NA         NA            NA      NA         NA
      9            NA  NA         NA            NA      NA         NA
      10           NA  NA         NA            NA      NA         NA
      11           NA  NA         NA            NA      NA         NA
      12           NA  NA         NA            NA      NA         NA
      13           NA  NA         NA            NA      NA         NA
      14           NA  NA         NA            NA      NA         NA
      15           NA  NA         NA            NA      NA         NA
      16           NA  NA         NA            NA      NA         NA
      17           NA  NA         NA            NA      NA         NA
      18           NA  NA         NA            NA      NA          1
      19           NA  NA         NA            NA      NA         NA
      20           NA  NA         NA            NA      NA         NA
      21           NA  NA         NA            NA      NA         NA
      22           NA  NA         NA            NA      NA         NA
      23           NA  NA         NA            NA      NA         NA
      24           NA  NA         NA            NA      NA         NA
      25           NA  NA         NA            NA      NA         NA
      26           NA  NA         NA            NA      NA         NA
      27           NA  NA         NA            NA      NA         NA
      28           NA  NA         NA            NA      NA         NA
      29           NA  NA         NA            NA      NA         NA
      30           NA  NA         NA            NA      NA         NA
      31           NA  NA         NA            NA      NA         NA
      32           NA  NA         NA            NA      NA         NA
      33           NA  NA         NA            NA      NA         NA
      34           NA  NA         NA            NA      NA         NA
      35           NA  NA         NA            NA      NA         NA
      36           NA  NA         NA            NA      NA         NA
      37           NA  NA         NA            NA      NA         NA
      38           NA  NA         NA            NA      NA         NA
      39           NA  NA         NA            NA      NA         NA
      40           NA  NA         NA            NA      NA         NA

---

    Code
      get_file_hashes(r)
    Output
      [1] "ac15b5874e652a09b0dcc8fe88bcc521" "f103b8cdc912de889e0d0f563635d307"
      [3] "2c01a7f6db428d0a9894752d798f5c41"

