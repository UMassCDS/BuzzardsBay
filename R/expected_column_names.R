expected_column_names <- list(

  calibrated =
    c("Date_Time", "Raw_DO", "Temp_DOLog", "DO", "DO_Pct_Sat", "Salinity_DOLog",
      "High_Range", "Temp_CondLog", "Spec_Cond", "Salinity"),

  # Note intermediate columns include individual flag columns for each data
  # column.  These will be combined in $Flags and then dropped.
  intermediate = c("Site",
                   "Date",
                   "Date_Time",
                   "Gen_QC",
                   "Flags",
                   "Time",
                   "Time_QC",
                   "Temp_DOLog",
                   "Temp_DOLog_Flag",
                   "Temp_DOLog_QC",
                   "Temp_CondLog",
                   "Temp_CondLog_Flag",
                   "Temp_CondLog_QC",
                   "Raw_DO",
                   "Raw_DO_Flag",
                   "Raw_DO_QC",
                   "DO",
                   "DO_Flag",
                   "DO_QC",
                   "DO_Calibration_QC",
                   "DO_Pct_Sat",
                   "DO_Pct_Sat_Flag",
                   "DO_Pct_Sat_QC",
                   "Salinity_DOLog",
                   "Salinity_DOLog_Flag",
                   "Salinity_DOLog_QC",
                   "Salinity",
                   "Salinity_Flag",
                   "Salinity_QC",
                   "Sal_Calibration_QC",
                   "High_Range",
                   "High_Range_Flag",
                   "High_Range_QC",
                   "Spec_Cond",
                   "Spec_Cond_Flag",
                   "Spec_Cond_QC",
                   "Cal",
                   "QA_Comment",
                   "Field_Comment")

)

# Set final QC data columns as a subset of the intermediate columns
# Drop individual flags, and DO Logger salinity
expected_column_names$qc_final <-
  expected_column_names$intermediate[!grepl("_Flag|Salinity_DOLog",
                                            expected_column_names$intermediate,
                                            ignore.case = TRUE)]
