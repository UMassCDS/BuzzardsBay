# report is correct

    Code
      report_site(site_dir, baywatchers = FALSE)
    Output
      Site BB_Data/2024/AB2 validated. Result files are up to date.
      
      Seasonal report written to BB_Data/2024/AB2/combined/report_AB2_2024.pdf
      Seasonal stats written to BB_Data/2024/AB2/combined/seasonal_stats_AB2_2024.csv
      Daily stats written to BB_Data/2024/AB2/combined/daily_stats_AB2_2024.csv

---

    Code
      read.csv(f)
    Output
               Date Min_DO Min_DO_Time Prop_Under_6 Duration_Under_6 Prop_Under_3
      1  2024-08-06    4.7    23:40:00         1.00              9.2         1.00
      2  2024-08-07    3.9    05:10:00         0.81             24.0         0.81
      3  2024-08-08    4.5    05:40:00         0.98             12.0         0.98
      4  2024-08-09     NA                       NA              0.0           NA
      5  2024-08-10    4.7    23:30:00         0.23              2.2         0.23
      6  2024-08-11    3.8    07:30:00         0.50             13.3         0.50
      7  2024-08-12    4.5    02:30:00         0.69              2.8         0.69
      8  2024-08-13    3.0    04:40:00         0.91             10.8         0.91
      9  2024-08-14    5.5    00:00:00         1.00             24.0         1.00
      10 2024-08-15    5.5    00:00:00         1.00             24.0         1.00
      11 2024-08-16    5.3    08:40:00         0.43             24.0         0.43
      12 2024-08-17    5.9    02:10:00         0.01              0.3         0.01
      13 2024-08-18    6.1    02:40:00         0.00              0.0         0.00
      14 2024-08-19    4.7    03:50:00         0.17              2.3         0.17
      15 2024-08-20    4.2    04:20:00         0.24              3.5         0.24
      16 2024-08-21    4.8    05:00:00         0.26              2.8         0.26
      17 2024-08-22    5.3    23:10:00         0.26              2.7         0.26
      18 2024-08-23    5.0    23:50:00         0.26              3.5         0.26
      19 2024-08-24    5.0    03:40:00         0.34              6.3         0.34
      20 2024-08-25    4.9    04:40:00         0.42             10.8         0.42
      21 2024-08-26    4.5    02:20:00         0.60              7.7         0.60
      22 2024-08-27    3.7    09:00:00         0.40              8.2         0.40
      23 2024-08-28    3.9    16:10:00         0.44              3.8         0.44
      24 2024-08-29    4.6    07:00:00         0.45              7.5         0.45
      25 2024-08-30    5.4    02:00:00         0.15              2.3         0.15
      26 2024-08-31    5.9    08:50:00         0.03              0.3         0.03
      27 2024-09-01    5.0    20:30:00         0.47              4.3         0.47
      28 2024-09-02    4.2    04:50:00         0.63             18.0         0.63
      29 2024-09-03    5.2    09:00:00         0.44              7.3         0.44
      30 2024-09-04    5.0    22:10:00         0.15              2.0         0.15
      31 2024-09-05    5.7    10:20:00         0.16              0.8         0.16
         Duration_Under_3 Mean_DO SD_DO Mean_Salinity SD_Salinity Range_DO
      1                 0     5.3   0.2          31.4         0.3      1.2
      2                 0     5.2   0.9          31.9         0.2      3.4
      3                 0     5.2   0.4          32.4         0.2      1.6
      4                 0      NA    NA            NA          NA       NA
      5                 0     6.5   0.9          31.3         0.5      3.2
      6                 0     6.0   1.3          31.8         0.4      4.2
      7                 0     5.8   1.1          31.6         0.5      3.0
      8                 0     5.2   0.8          31.6         0.3      3.7
      9                 0     5.5   0.0          31.8         0.5      0.0
      10                0     5.5   0.0          30.9         0.3      0.0
      11                0     6.9   1.3          30.9         0.2      3.8
      12                0     7.7   0.9          30.9         0.2      3.5
      13                0     7.2   0.6          30.8         0.2      2.4
      14                0     6.6   0.7          30.9         0.3      3.2
      15                0     6.4   0.7          30.9         0.4      3.8
      16                0     6.6   1.1          31.3         0.3      5.0
      17                0     6.7   0.9          31.2         0.3      3.3
      18                0     6.9   1.0          30.6         0.5      4.1
      19                0     6.7   1.1          30.4         0.4      4.1
      20                0     6.4   0.9          31.1         0.6      3.1
      21                0     5.8   0.8          31.2         0.4      3.0
      22                0     6.7   1.7          30.7         0.3      5.6
      23                0     6.2   1.4          31.0         0.4      4.9
      24                0     6.3   0.9          31.2         0.3      3.1
      25                0     7.0   0.9          31.5         0.3      3.4
      26                0     7.0   0.8          31.5         0.3      2.7
      27                0     6.1   0.5          31.4         0.4      2.1
      28                0     5.7   0.6          31.7         0.3      2.8
      29                0     6.5   1.0          31.8         0.3      3.7
      30                0     6.6   0.9          31.8         0.2      3.9
      31                0     6.2   0.2          31.7         0.2      0.9
         Range_DO_Sat Min_Temp Max_Temp
      1            17    24.67    25.91
      2            49    24.23    25.14
      3            22    23.72    24.29
      4            NA       NA       NA
      5            46    25.02    26.81
      6            62    24.50    26.20
      7            44    24.46    25.41
      8            70    23.34    25.14
      9           101    23.05    25.25
      10           64    23.52    25.54
      11           54    24.01    25.20
      12           50    24.35    25.12
      13           34    24.40    24.92
      14           47    24.20    25.03
      15           54    24.05    25.20
      16           73    23.41    24.92
      17           47    22.88    24.42
      18           60    22.81    24.58
      19           60    22.82    24.98
      20           46    22.95    25.16
      21           43    23.21    24.55
      22           80    23.50    25.27
      23           70    23.14    25.08
      24           45    23.58    24.80
      25           48    23.48    24.40
      26           39    23.47    24.99
      27           32    23.41    24.95
      28           40    23.21    24.31
      29           54    22.48    23.91
      30           56    22.55    24.31
      31           13    22.74    23.45

