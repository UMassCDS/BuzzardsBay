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
                 Waterbody Site Latitude Longitude Depth Depth_QC Unique_ID
      1  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         1
      2  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         2
      3  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         3
      4  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         4
      5  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         5
      6  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         6
      7  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         7
      8  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         8
      9  Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A         9
      10 Apponagansett Bay  AB2     #N/A      #N/A    DR     #N/A        10
      11 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        11
      12 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        12
      13 Apponagansett Bay  AB2     #N/A      #N/A    DR     #N/A        13
      14 Apponagansett Bay  AB2     #N/A      #N/A    DR     #N/A        14
      15 Apponagansett Bay  AB2     #N/A      #N/A    DR     #N/A        15
      16 Apponagansett Bay  AB2     #N/A      #N/A    DR     #N/A        16
      17 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        17
      18 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        18
      19 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        19
      20 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        20
      21 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        21
      22 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        22
      23 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        23
      24 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        24
      25 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        25
      26 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        26
      27 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        27
      28 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        28
      29 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        29
      30 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        30
      31 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        31
      32 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        32
      33 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        33
      34 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        34
      35 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        35
      36 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        36
      37 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        37
      38 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        38
      39 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        39
      40 Apponagansett Bay  AB2     #N/A      #N/A  #N/A     #N/A        40
               Date           Date_Time Julian_Date Gen_QC Flags     Time Time_QC
      1  2024-08-06 2024-08-06 14:40:00         219   #N/A    NA 14:40:00    #N/A
      2  2024-08-06 2024-08-06 14:50:00         219     12    NA 14:50:00    #N/A
      3  2024-08-06 2024-08-06 15:00:00         219   #N/A    NA 15:00:00    #N/A
      4  2024-08-06 2024-08-06 15:10:00         219   #N/A    NA 15:10:00    #N/A
      5  2024-08-06 2024-08-06 15:20:00         219   #N/A    NA 15:20:00    #N/A
      6  2024-08-06 2024-08-06 15:30:00         219   #N/A    NA 15:30:00    #N/A
      7  2024-08-06 2024-08-06 15:40:00         219   #N/A    NA 15:40:00    #N/A
      8  2024-08-06 2024-08-06 15:50:00         219   #N/A    NA 15:50:00    #N/A
      9  2024-08-06 2024-08-06 16:00:00         219   #N/A    NA 16:00:00    #N/A
      10 2024-08-06 2024-08-06 16:10:00         219      1    NA 16:10:00    #N/A
      11 2024-08-06 2024-08-06 16:20:00         219      3    NA 16:20:00    #N/A
      12 2024-08-06 2024-08-06 16:30:00         219      4    NA 16:30:00    #N/A
      13 2024-08-06 2024-08-06 16:40:00         219      7    NA 16:40:00    #N/A
      14 2024-08-06 2024-08-06 16:50:00         219      9    NA 16:50:00    #N/A
      15 2024-08-06 2024-08-06 17:00:00         219     90    NA 17:00:00    #N/A
      16 2024-08-06 2024-08-06 17:10:00         219     91    NA 17:10:00    #N/A
      17 2024-08-06 2024-08-06 17:20:00         219     11    NA 17:20:00    #N/A
      18 2024-08-06 2024-08-06 17:30:00         219     12    NA 17:30:00    #N/A
      19 2024-08-06 2024-08-06 17:40:00         219     13    NA 17:40:00    #N/A
      20 2024-08-06 2024-08-06 17:50:00         219     14    NA 17:50:00    #N/A
      21 2024-08-06 2024-08-06 18:00:00         219   #N/A    NA 18:00:00    #N/A
      22 2024-08-06 2024-08-06 18:10:00         219   #N/A    NA 18:10:00    #N/A
      23 2024-08-06 2024-08-06 18:20:00         219   #N/A    NA 18:20:00    #N/A
      24 2024-08-06 2024-08-06 18:30:00         219   #N/A    NA 18:30:00    #N/A
      25 2024-08-06 2024-08-06 18:40:00         219   #N/A    NA 18:40:00    #N/A
      26 2024-08-06 2024-08-06 18:50:00         219   #N/A    NA 18:50:00    #N/A
      27 2024-08-06 2024-08-06 19:00:00         219   #N/A    NA 19:00:00    #N/A
      28 2024-08-06 2024-08-06 19:10:00         219   #N/A    NA 19:10:00    #N/A
      29 2024-08-06 2024-08-06 19:20:00         219   #N/A    NA 19:20:00    #N/A
      30 2024-08-06 2024-08-06 19:30:00         219   #N/A    NA 19:30:00    #N/A
      31 2024-08-06 2024-08-06 19:40:00         219   #N/A    NA 19:40:00    #N/A
      32 2024-08-06 2024-08-06 19:50:00         219   #N/A    NA 19:50:00    #N/A
      33 2024-08-06 2024-08-06 20:00:00         219   #N/A    NA 20:00:00    #N/A
      34 2024-08-06 2024-08-06 20:10:00         219   #N/A    NA 20:10:00    #N/A
      35 2024-08-06 2024-08-06 20:20:00         219   #N/A    NA 20:20:00    #N/A
      36 2024-08-06 2024-08-06 20:30:00         219   #N/A    NA 20:30:00    #N/A
      37 2024-08-06 2024-08-06 20:40:00         219   #N/A    NA 20:40:00    #N/A
      38 2024-08-06 2024-08-06 20:50:00         219   #N/A    NA 20:50:00    #N/A
      39 2024-08-06 2024-08-06 21:00:00         219   #N/A    NA 21:00:00    #N/A
      40 2024-08-06 2024-08-06 21:10:00         219   #N/A    NA 21:10:00    #N/A
         Temp_DOLog Temp_DOLog_QC Temp_CondLog Temp_CondLog_QC Raw_DO Raw_DO_QC   DO
      1        24.4          #N/A        26.07            #N/A   6.57      #N/A  5.3
      2       24.92          #N/A        25.72            #N/A   6.71      #N/A 5.41
      3       25.06          #N/A        25.82            #N/A   6.57      #N/A  5.3
      4       24.98          #N/A        25.71            #N/A   6.41      #N/A 5.17
      5       24.94          #N/A        25.67            #N/A   6.59      #N/A 5.31
      6        24.9          #N/A        25.64            #N/A   6.73      #N/A 5.42
      7       24.94          #N/A        25.74            #N/A   7.24      #N/A 5.83
      8       25.04          #N/A        25.84            #N/A   7.14      #N/A 5.76
      9        25.1          #N/A         25.9            #N/A   6.91      #N/A 5.57
      10         DR          #N/A           DR            #N/A     DR      #N/A   DR
      11      25.14          #N/A        25.87            #N/A   6.98      #N/A 5.63
      12      25.12          #N/A        25.84            #N/A   6.94      #N/A 5.59
      13         DR          #N/A           DR            #N/A     DR      #N/A   DR
      14         DR          #N/A           DR            #N/A     DR      #N/A   DR
      15         DR          #N/A           DR            #N/A     DR      #N/A   DR
      16         DR          #N/A           DR            #N/A     DR      #N/A   DR
      17      24.58          #N/A        25.23            #N/A    6.4      #N/A 5.15
      18      24.44          #N/A        25.15            #N/A   6.42      #N/A 5.16
      19      24.42          #N/A        25.08            #N/A   6.44      #N/A 5.17
      20      24.28          #N/A        24.98            #N/A   6.34      #N/A 5.09
      21      24.22          #N/A         24.9            #N/A   6.61      #N/A 5.31
      22      24.08          #N/A        24.75            #N/A   6.72      #N/A 5.39
      23      23.98          #N/A         24.7            #N/A   6.78      #N/A 5.44
      24      23.96          #N/A         24.7            #N/A   6.72      #N/A 5.39
      25      23.94          #N/A        24.67            #N/A    6.6      #N/A 5.29
      26      23.94          #N/A        24.68            #N/A   6.52      #N/A 5.23
      27      23.96          #N/A         24.7            #N/A   6.51      #N/A 5.22
      28      23.98          #N/A        24.73            #N/A   6.52      #N/A 5.23
      29         24          #N/A        24.75            #N/A   6.47      #N/A 5.19
      30         24          #N/A        24.73            #N/A     DR         1 5.15
      31         24          #N/A        24.73            #N/A   6.57         3 5.27
      32      24.02          #N/A        24.83            #N/A   6.65         4 5.34
      33      24.18          #N/A        24.98            #N/A     DR         7 5.53
      34       24.2          #N/A        24.94            #N/A     DR         9 5.48
      35       24.2          #N/A        24.94            #N/A     DR        90  5.4
      36      24.24          #N/A        24.98            #N/A     DR        91 5.36
      37      24.24          #N/A        24.98            #N/A   6.57        11 5.28
      38      24.24          #N/A        24.97            #N/A    6.7        12 5.38
      39      24.22          #N/A        24.92            #N/A    6.4        13 5.14
      40      24.24          #N/A        25.02            #N/A   6.47        14  5.2
         DO_QC DO_Calibration_QC DO_Pct_Sat DO_Pct_Sat_QC Salinity Salinity_QC
      1   #N/A              #N/A       75.6          #N/A  30.6829        #N/A
      2   #N/A              #N/A       77.9          #N/A  30.9357        #N/A
      3   #N/A              #N/A       76.5          #N/A  30.9029        #N/A
      4   #N/A              #N/A       74.5          #N/A  30.9885        #N/A
      5   #N/A              #N/A       76.6          #N/A  31.0471        #N/A
      6   #N/A              #N/A       78.2          #N/A  31.0872        #N/A
      7   #N/A              #N/A       84.1          #N/A  31.0311        #N/A
      8   #N/A              #N/A       83.1          #N/A  30.9843        #N/A
      9   #N/A              #N/A       80.5          #N/A  30.9467        #N/A
      10  #N/A              #N/A         DR          #N/A       DR        #N/A
      11  #N/A              #N/A       81.4          #N/A   30.988        #N/A
      12  #N/A              #N/A       80.9          #N/A   31.035        #N/A
      13  #N/A              #N/A         DR          #N/A       DR        #N/A
      14  #N/A              #N/A         DR          #N/A       DR        #N/A
      15  #N/A              #N/A         DR          #N/A       DR        #N/A
      16  #N/A              #N/A         DR          #N/A       DR        #N/A
      17  #N/A              #N/A       73.9          #N/A  31.3728        #N/A
      18  #N/A              #N/A       73.9          #N/A  31.4347        #N/A
      19  #N/A              #N/A       74.2          #N/A  31.4686        #N/A
      20  #N/A              #N/A       72.8          #N/A  31.5146        #N/A
      21  #N/A              #N/A       75.8          #N/A  31.5909        #N/A
      22  #N/A              #N/A       76.9          #N/A  31.6587        #N/A
      23  #N/A              #N/A       77.4          #N/A   31.733        #N/A
      24  #N/A              #N/A       76.7          #N/A  31.7341        #N/A
      25  #N/A              #N/A       75.3          #N/A  31.7638        #N/A
      26  #N/A              #N/A       74.4          #N/A  31.7531        #N/A
      27  #N/A              #N/A       74.3          #N/A    31.74        #N/A
      28  #N/A              #N/A       74.5          #N/A  31.7339        #N/A
      29  #N/A              #N/A       73.9          #N/A  31.7255        #N/A
      30  #N/A              #N/A       73.4          #N/A  31.6775        #N/A
      31  #N/A              #N/A       75.1          #N/A  31.7256        #N/A
      32  #N/A              #N/A         76          #N/A  31.6744        #N/A
      33  #N/A              #N/A         79          #N/A  31.6046        #N/A
      34  #N/A              #N/A       78.4          #N/A   31.627        #N/A
      35  #N/A              #N/A       77.1          #N/A  31.4947        #N/A
      36  #N/A              #N/A       76.6          #N/A  31.5634        #N/A
      37  #N/A              #N/A       75.4          #N/A  31.5669        #N/A
      38  #N/A              #N/A       76.9          #N/A  31.5634        #N/A
      39  #N/A              #N/A       73.5          #N/A  31.5859        #N/A
      40  #N/A              #N/A       74.3          #N/A  31.4907        #N/A
         Sal_Calibration_QC High_Range High_Range_QC Spec_Cond Spec_Cond_QC  Cal
      1                #N/A    25544.5          #N/A   47188.5         #N/A    1
      2                #N/A    25556.3          #N/A   47535.9         #N/A #N/A
      3                #N/A    25583.4          #N/A   47490.7         #N/A #N/A
      4                #N/A    25591.9          #N/A   47608.3         #N/A #N/A
      5                #N/A    25615.7          #N/A   47688.8         #N/A #N/A
      6                #N/A    25630.9          #N/A   47743.8         #N/A #N/A
      7                #N/A    25641.1          #N/A   47666.8         #N/A #N/A
      8                #N/A    25658.1          #N/A   47602.7         #N/A #N/A
      9                #N/A    25661.5          #N/A     47551         #N/A #N/A
      10               #N/A         DR          #N/A        DR         #N/A #N/A
      11               #N/A    25678.6          #N/A   47607.7         #N/A #N/A
      12               #N/A      25699          #N/A   47672.2         #N/A #N/A
      13               #N/A         DR          #N/A        DR         #N/A #N/A
      14               #N/A         DR          #N/A        DR         #N/A #N/A
      15               #N/A         DR          #N/A        DR         #N/A #N/A
      16               #N/A         DR          #N/A        DR         #N/A #N/A
      17               #N/A    25641.1          #N/A   48135.6         #N/A #N/A
      18               #N/A    25646.2          #N/A   48220.3         #N/A #N/A
      19               #N/A      25636          #N/A   48266.9         #N/A #N/A
      20               #N/A    25619.1          #N/A   48329.9         #N/A #N/A
      21               #N/A    25634.3          #N/A   48434.4         #N/A #N/A
      22               #N/A    25607.2          #N/A   48527.1         #N/A #N/A
      23               #N/A      25636          #N/A   48628.8         #N/A #N/A
      24               #N/A    25637.7          #N/A   48630.4         #N/A #N/A
      25               #N/A    25644.5          #N/A     48671         #N/A #N/A
      26               #N/A    25642.8          #N/A   48656.3         #N/A #N/A
      27               #N/A    25644.5          #N/A   48638.4         #N/A #N/A
      28               #N/A    25656.4          #N/A   48630.1         #N/A #N/A
      29               #N/A    25661.5          #N/A   48618.6         #N/A #N/A
      30               #N/A    25617.4          #N/A   48552.9         #N/A #N/A
      31               #N/A      25653          #N/A   48618.7         #N/A #N/A
      32               #N/A    25668.3          #N/A   48548.7         #N/A #N/A
      33               #N/A    25695.6          #N/A   48453.1         #N/A #N/A
      34               #N/A    25692.2          #N/A   48483.8         #N/A #N/A
      35               #N/A      25597          #N/A   48302.5         #N/A #N/A
      36               #N/A    25668.3          #N/A   48396.7         #N/A #N/A
      37               #N/A    25671.7          #N/A   48401.5         #N/A #N/A
      38               #N/A    25664.9          #N/A   48396.8         #N/A #N/A
      39               #N/A    25656.4          #N/A   48427.5         #N/A #N/A
      40               #N/A    25639.4          #N/A   48297.2         #N/A #N/A
         QA_Comment Field_Comment Exclude
      1        #N/A            NA    #N/A
      2        #N/A            NA    #N/A
      3        #N/A            NA    #N/A
      4        #N/A            NA    #N/A
      5        #N/A            NA    #N/A
      6        #N/A            NA    #N/A
      7        #N/A            NA    #N/A
      8        #N/A            NA    #N/A
      9        #N/A            NA    #N/A
      10       #N/A            NA    #N/A
      11       #N/A            NA    #N/A
      12       #N/A            NA    #N/A
      13       #N/A            NA    #N/A
      14       #N/A            NA    #N/A
      15       #N/A            NA    #N/A
      16       #N/A            NA    #N/A
      17       #N/A            NA    #N/A
      18       #N/A            NA    #N/A
      19       #N/A            NA    #N/A
      20       #N/A            NA    #N/A
      21       #N/A            NA    #N/A
      22       #N/A            NA    #N/A
      23       #N/A            NA    #N/A
      24       #N/A            NA    #N/A
      25       #N/A            NA    #N/A
      26       #N/A            NA    #N/A
      27       #N/A            NA    #N/A
      28       #N/A            NA    #N/A
      29       #N/A            NA    #N/A
      30       #N/A            NA    #N/A
      31       #N/A            NA    #N/A
      32       #N/A            NA    #N/A
      33       #N/A            NA    #N/A
      34       #N/A            NA    #N/A
      35       #N/A            NA    #N/A
      36       #N/A            NA    #N/A
      37       #N/A            NA    #N/A
      38       #N/A            NA    #N/A
      39       #N/A            NA    #N/A
      40       #N/A            NA    #N/A

---

    Code
      get_file_hashes(r)
    Output
      [1] "3dad19b11817320fad73220b430a7115" "8a2547ef066f4c32b99252b4fd66a601"
      [3] "c4bfdbae348e1afd401e5de53f11b91d"

