# qc_deployment() works with import type 0 (simple CSV)

    Code
      head(as.data.frame(d2), 2)
    Output
        Site       Date           Date_Time Gen_QC     Flags     Time Time_QC
      1  SIM 2025-01-02 2025-01-02 14:50:02   9999 TDsl:TCsl 14:50:02      NA
      2  SIM 2025-01-02 2025-01-02 15:00:02   9999 TDsl:TCsl 15:00:02      NA
        Temp_DOLog Temp_DOLog_QC Temp_CondLog Temp_CondLog_QC Raw_DO Raw_DO_QC    DO
      1      14.53            NA         9.92              NA  10.41        NA  8.69
      2       9.49            NA         9.38              NA  12.71        NA 10.54
        DO_QC DO_Calibration_QC DO_Pct_Sat DO_Pct_Sat_QC Salinity Salinity_QC
      1    NA                NA     122.26            NA    29.20          NA
      2    NA                NA     134.17            NA    29.17          NA
        Sal_Calibration_QC High_Range High_Range_QC Spec_Cond Spec_Cond_QC Cal
      1                 NA    32291.2            NA   47260.6           NA   1
      2                 NA    31828.7            NA   47363.4           NA  NA
          Depth Depth_QC QA_Comment Field_Comment
      1 0.00000       NA         NA            NA
      2 0.00997       NA         NA            NA

# qc_deployment() works with U24 and U26 loggers

    Code
      flags
    Output
         row  Flags
      1    1     Sj
      2    2     Sj
      3  117     Sj
      4  118 Sj:Ssl
      5  119    Ssl
      6  120 Sj:Ssl
      7  121 Sj:Ssl
      8  122 Sj:Ssl
      9  123    Ssl
      10 124    Ssl
      11 125 Sj:Ssl
      12 126 Sj:Ssl
      13 127 Sj:Ssl
      14 128 Sj:Ssl
      15 129 Sj:Ssl
      16 130     Sj
      17 131     Sj
      18 261     Sj
      19 262 Sj:Ssl
      20 263 Sj:Ssl

---

    Code
      as.data.frame(d[50:53, ])
    Output
        Site       Date           Date_Time Gen_QC Flags     Time Time_QC Temp_DOLog
      1  RB1 2023-06-02 2023-06-02 19:20:00     NA  <NA> 19:20:00      NA      21.48
      2  RB1 2023-06-02 2023-06-02 19:30:00     NA  <NA> 19:30:00      NA      21.46
      3  RB1 2023-06-02 2023-06-02 19:40:00     NA  <NA> 19:40:00      NA      21.50
      4  RB1 2023-06-02 2023-06-02 19:50:00     NA  <NA> 19:50:00      NA      21.54
        Temp_DOLog_QC Temp_CondLog Temp_CondLog_QC Raw_DO Raw_DO_QC   DO DO_QC
      1            NA        22.55              NA   7.98        NA 6.90    NA
      2            NA        22.47              NA   8.08        NA 6.98    NA
      3            NA        22.53              NA   7.93        NA 6.86    NA
      4            NA        22.59              NA   7.90        NA 6.83    NA
        DO_Calibration_QC DO_Pct_Sat DO_Pct_Sat_QC Salinity Salinity_QC
      1                NA       92.6            NA  29.1648          NA
      2                NA       93.7            NA  29.1880          NA
      3                NA       92.0            NA  29.1684          NA
      4                NA       91.8            NA  29.1407          NA
        Sal_Calibration_QC High_Range High_Range_QC Spec_Cond Spec_Cond_QC Cal
      1                 NA    30971.9            NA   45093.0           NA  NA
      2                 NA    30943.8            NA   45125.2           NA  NA
      3                 NA    30964.3            NA   45098.0           NA  NA
      4                 NA    30977.1            NA   45059.6           NA  NA
        QA_Comment Field_Comment
      1         NA            NA
      2         NA            NA
      3         NA            NA
      4         NA            NA

# qc_deployment()  MX801 date time bug is fixed

    Code
      as.data.frame(d2[49:51, ])
    Output
        Site       Date           Date_Time Gen_QC Flags     Time Time_QC Temp_DOLog
      1  OB1 2025-07-24 2025-07-24 23:50:00     NA  <NA> 23:50:00      NA   21.77596
      2  OB1 2025-07-25 2025-07-25 00:00:00     NA  <NA> 00:00:00      NA   21.85633
      3  OB1 2025-07-25 2025-07-25 00:10:00     NA  <NA> 00:10:00      NA   21.98138
        Temp_DOLog_QC Temp_CondLog Temp_CondLog_QC   Raw_DO Raw_DO_QC       DO DO_QC
      1            NA     21.69342              NA 9.542710        NA 7.931957    NA
      2            NA     21.72330              NA 9.419030        NA 7.830386    NA
      3            NA     21.87265              NA 9.345158        NA 7.771935    NA
        DO_Calibration_QC DO_Pct_Sat DO_Pct_Sat_QC Salinity Salinity_QC
      1                NA   108.6740            NA 31.76196          NA
      2                NA   107.4321            NA 31.75383          NA
      3                NA   106.8469            NA 31.71777          NA
        Sal_Calibration_QC High_Range High_Range_QC Spec_Cond Spec_Cond_QC Cal
      1                 NA   45524.43            NA  48593.38           NA  NA
      2                 NA   45542.15            NA  48582.70           NA  NA
      3                 NA   45636.58            NA  48535.73           NA  NA
           Depth Depth_QC QA_Comment Field_Comment
      1 3.785083       NA         NA            NA
      2 3.704349       NA         NA            NA
      3 3.638687       NA         NA            NA

# man/qc_deployment() checks specific flags

    Code
      d[sel_rows, sel_cols]
    Output
         Gen_QC          Flags Depth Depth_QC
      21   9999             Wh    10        7
      22   9999        TCsl:Wh    10        7
      23      9 TCsl:Re:Rsl:Wh    10        7
      24      9      Re:Rsl:Wh    10        7
      31     91             Wl    -1        7
      32   9999        TCsl:Wl    -1        7
      33     91 TCsl:Re:Rsl:Wl    -1        7
      34     91      Re:Rsl:Wl    -1        7

