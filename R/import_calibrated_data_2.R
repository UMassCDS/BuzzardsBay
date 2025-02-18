# nolint start: cyclocomp_linter
import_calibrated_data_2 <- function(paths) {

  # This is for data format type 2 which uses the MX801 logger producing a
  # single .xls file  that contains output from both the
  # Dissolved Oxygen and the Conductivity Sensors.  The details are stored in
  # their own tab.

  placements <- read_and_format_placements(paths$placements)

  # Set input calibration data paths
  l <- list.files(paths$deployment_cal_dir, full.names = TRUE)
  l <- gsub("[/\\\\]+", .Platform$file.sep, l)

  input_path = grep("\\.xlsx$", l, value = TRUE, ignore.case = TRUE)


  # Check that we found 1 and only 1 of each type of file in the calibration dir
  has_one <-length(input_path) == 1
  if(!(has_one)){
    stop("Expected one and only one .xlsx file in the calibration directory ",
         "for an MX801 logger: ", paths$deployment_cal_dir,
         " found ", length(input_path))
  }

  # Print input paths:

  # Convert input files to relative paths (for printing)
  relative_paths <- gsub(paste0("^", paths$base_dir, "[/\\\\]*"), "",
                         input_path, ignore.case = TRUE)

  cat("\nImporting calibrated data Type 2 - MX801 .xlsx file \n",
      "\twith import_calibrated_data_2()\n\n")

  cat("Buzzards Bay base directory:\n\t",
      paths$base_dir, "\n")


  cat("Using these input files (relative to base dir):\n\t",
      paste( "Single .xlsx input file", " = ", relative_paths, collapse = "\n\t"),
      "\n", sep = "")

  miss <- !sapply(input_path, file.exists)
  if(any(miss)){
    stop("Missing input files:\n",
         paste(names(input_path[miss]), " = ", relative_paths[miss],
               collapse = "\n\t"), sep = "")
  }


  #============================================================================#
  # Process Metadata                                                        ####
  #============================================================================#

  # From HOBOware Details.txt files
  md <- parse_mx801_details(input_path)


  # Read data from file
  d <-  read_mx801_data(input_path)

  # Record logging interval in minutes
  t <- d$Date_Time[1:6] |> lubridate::ymd_hms()
  intervals <- (t[2:6]  - t[1:5]) |> as.numeric(units = "mins")
  if(!all(intervals == intervals[1])) {
    stop(input_path, " appears to have a varying interval")
  }
  md$logging_interval_min <- intervals[1]


  # Other information
  md$site <- paths$site
  md$deployment <- paste0(paths$site, "_", paths$deployment_date)
  md$deployment_date <- as.character(paths$deployment_date)
  md$auto_qc_date <- lubridate::today() |> as.character()


  # Check for consistancy in start and end times
  if(md$calibration_start != d$Date_Time[1])
    stop("Inconsistent start times.")

  if(md$calibration_end != d$Date_Time[nrow(d)])
    stop("Inconsistent end times.")


  # Calculate the ratio between calibrartion value from YSI ("TRUTH") to
  #  the uncalibrated logger value

  md_order <- c("site",
                "deployment",
                "deployment_date",
                "calibration_start",
                "calibration_end",
                "pct_calibrated",
                "n_records",
                "pct_immediate_rejection",
                "pct_flagged_for_review",
                "logging_interval_min",
                "timezone",
                "auto_qc_date",
                "do_calibration",
                "do_deployment",
                "do_device",
                "cond_calibration",
               "cond_deployment",
                "cond_device")

  # Create placeholder items which will be filled in later
  md$pct_calibrated <- NA
  md$pct_immediate_rejection <- NA
  md$pct_flagged_for_review <- NA
  md$n_records <- NA
  md$do_deployment <- NA
  md$cond_deployment <- NA

  miss <- setdiff(md_order, names(md))
  stopifnot(all(md_order %in% names(md)))

  md <- md[md_order]


  # For debugging: cat(yaml::as.yaml(md))

  #============================================================================#
  # Process data
  #============================================================================#

  #----------------------------------------------------------------------------#
  # Read and Process Calibrated DO and Conductivity Tables                  ####
  #----------------------------------------------------------------------------#

  # Check SN against placements
  check_placement(md$do_device$serial_number, type = "DO", placements,
                  paths$deployment_date,
                  paths$site)
  check_placement(md$cond_device$serial_number, type = "Cond", placements,
                  paths$deployment_date,
                  paths$site)


  # Verify that the two Salinities are identical
  if(!all(d$Salinity == d$Salinity_DOLog | is.na(d$Salinity)))
    stop("The salinity column from the calibrated DO CSV file should ",
         "match the salinity column from the calibrated Conductivity file, but they don't.")


  return(list(d = d, md = md))

}
# nolint end: cyclocomp_linter
