# qc_deployment() works

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

