# qc_deployment() works

    Code
      as.data.frame(head(d))
    Output
        Site       Date           Date_Time Gen_QC Flags     Time Time_QC Temp_DOLog
      1  RB1 2023-06-02 2023-06-02 11:10:00   9999    Sj 11:10:00      NA      22.00
      2  RB1 2023-06-02 2023-06-02 11:20:00   9999    Sj 11:20:00      NA      21.32
      3  RB1 2023-06-02 2023-06-02 11:30:00     NA  <NA> 11:30:00      NA      20.82
      4  RB1 2023-06-02 2023-06-02 11:40:00     NA  <NA> 11:40:00      NA      20.74
      5  RB1 2023-06-02 2023-06-02 11:50:00     NA  <NA> 11:50:00      NA      20.70
      6  RB1 2023-06-02 2023-06-02 12:00:00     NA  <NA> 12:00:00      NA      20.72
        Temp_DOLog_QC Temp_CondLog Temp_CondLog_QC Raw_DO Raw_DO_QC   DO DO_QC
      1            NA        22.22              NA   7.37        NA 6.41    NA
      2            NA        21.81              NA   7.57        NA 6.54    NA
      3            NA        21.70              NA   7.10        NA 6.13    NA
      4            NA        21.73              NA   7.33        NA 6.33    NA
      5            NA        21.73              NA   7.06        NA 6.09    NA
      6            NA        21.75              NA   7.89        NA 6.81    NA
        DO_Calibration_QC DO_Pct_Sat DO_Pct_Sat_QC Salinity Salinity_QC
      1                NA       86.5            NA  28.4735          NA
      2                NA       87.7            NA  29.4197          NA
      3                NA       81.4            NA  29.4834          NA
      4                NA       83.9            NA  29.4592          NA
      5                NA       80.8            NA  29.4879          NA
      6                NA       90.3            NA  29.4921          NA
        Sal_Calibration_QC High_Range High_Range_QC Spec_Cond Spec_Cond_QC Cal
      1                 NA    30064.6            NA   44133.7           NA   1
      2                 NA    30697.7            NA   45446.0           NA  NA
      3                 NA    30687.6            NA   45534.1           NA  NA
      4                 NA    30685.1            NA   45500.6           NA  NA
      5                 NA    30712.8            NA   45540.3           NA  NA
      6                 NA    30730.4            NA   45546.1           NA  NA
        QA_Comment Field_Comment
      1         NA            NA
      2         NA            NA
      3         NA            NA
      4         NA            NA
      5         NA            NA
      6         NA            NA

