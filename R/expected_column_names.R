# NOTE: Use get_expected_columns() instead of referencing these lists directly.

# Define lists of expected and optional column names at different points in the
# pipeline.


expected_column_names <- list(
# nolint start: indentation_linter
  calibrated =
    c("Date_Time",
      "Raw_DO",
      "Temp_DOLog",
      "DO",
      "DO_Pct_Sat",
      "Salinity_DOLog",
      "High_Range",
      "Temp_CondLog",
      "Spec_Cond",
      "Salinity",
      "Latitude",  # optional
      "Longitude", # optional
      "Depth" ),     # optional


  # Note intermediate columns include individual flag columns for each data
  # column.  These will be combined in $Flags and then dropped.
  qc_intermediate = c("Site",
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
                      "Latitude",  # optional
                      "Longitude", # optional
                      "Depth",     # optional
                      "QA_Comment",
                      "Field_Comment"),


  final_all = c("Waterbody",                              # This is the full set of final columns, used in the archive result file
                "WPP_Station_Identifier",
                "Site",
                "Latitude",
                "Longitude",
                "Depth",
                "Unique_ID",
                "Date",
                "Date_Time",
                "Julian_Date",
                "Gen_QC",
                "Flags",
                "Time",
                "Time_QC",
                "Temp_DOLog",
                "Temp_DOLog_QC",
                "Temp_CondLog",
                "Temp_CondLog_QC",
                "Raw_DO",
                "Raw_DO_QC",
                "DO",
                "DO_QC",
                "DO_Calibration_QC",
                "DO_Pct_Sat",
                "DO_Pct_Sat_QC",
                "Salinity",
                "Salinity_QC",
                "Sal_Calibration_QC",
                "High_Range",
                "High_Range_QC",
                "Spec_Cond",
                "Spec_Cond_QC",
                "Cal",
                "QA_Comment",
                "Field_Comment",
                "Exclude"),

  final_WPP = NULL,                                     # WPP has the same columns as the archive result file, though this could change


  final_core = c("Site",                                # A concise subset of columns for the core result file
                 "Depth",
                 "Unique_ID",
                 "Date_Time",
                 "Julian_Date",
                 "Temp_CondLog",
                 "DO",
                 "DO_Pct_Sat",
                 "Salinity",
                 "High_Range",
                 "QA_Comment",
                 "Field_Comment"),

  final_sensors = c("Depth",                            # Sensor metric columns that will be set to "DR" in WPP result file based on QC rejection flags
                    "Temp_DOLog",
                    "Temp_CondLog",
                    "Raw_DO",
                    "DO",
                    "DO_Pct_Sat",
                    "Salinity",
                    "High_Range",
                    "Spec_Cond")
    )
# nolint end

expected_column_names$final_WPP <- expected_column_names$final_all    # final_WPP the same as final_all for now


# Set final QC data columns as a subset of the intermediate columns
# Drop individual flags, and DO Logger salinity
# nolint start: indentation_linter
expected_column_names$qc_final <-
  expected_column_names$qc_intermediate[
    !grepl("_Flag|Salinity_DOLog",
           expected_column_names$qc_intermediate,
           ignore.case = TRUE)]
# nolint end
# These are optional column names for each type
# (calibrated, intermediate, and qc_final)
expected_column_names$optional_calibrated <- c("Latitude", "Longitude",
                                               "Depth")
expected_column_names$optional_qc_intermediate <- c("Latitude", "Longitude",
                                                    "Depth")
expected_column_names$optional_qc_final <- c("Latitude", "Longitude", "Depth")
