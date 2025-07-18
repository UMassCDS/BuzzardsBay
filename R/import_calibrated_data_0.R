# nolint start: cyclocomp_linter
# setup_example_dir(year_filter = 2025, delete_old = TRUE, site_filter = "SIM")
import_calibrated_data_0 <- function(paths) {

  # This is for data format 0 which is a fall-back, simple import
  # From CSV and YML files

  placements <- read_and_format_placements(paths$placements)

  # Set input calibration data paths
  l <- list.files(paths$deployment_cal_dir, full.names = TRUE)
  l <- gsub("[/\\\\]+", .Platform$file.sep, l)

  input_paths =
    list(data = grep("\\.csv$", l, value = TRUE, ignore.case = TRUE),
         metadata = grep("\\.yml$", l, value = TRUE, ignore.case = TRUE))


  # Check that we found 1 and only 1 of each type of file in the calibration dir
  has_one <- sapply(input_paths, length) == 1
  if(!all(has_one)){
    stop("Couldn't find required files in calibration dir: ",
         paste(names(input_paths)[!has_one], collapse = ", "))
  }

  # Print input paths:

  # Convert input files to relative paths (for printing)
  relative_paths <- gsub(paste0("^", paths$base_dir, "[/\\\\]*"), "",
                         unlist(input_paths), ignore.case = TRUE)

  cat("\nImporting calibrated data Type 0 - simple CSV and YAML import \n",
      "\twith import_calibrated_data_0()\n\n")

  cat("Buzzards Bay base directory:\n\t",
      paths$base_dir, "\n")

  cat("Using these input files (relative to base dir):\n\t",
      paste(names(input_paths), " = ", relative_paths, collapse = "\n\t"),
      "\n", sep = "")

  miss <- !sapply(input_paths, file.exists)
  if(any(miss)){
    stop("Missing input files:\n",
         paste(names(input_paths[miss]), " = ", relative_paths[miss],
               collapse = "\n\t"), sep = "")
  }

  # Process Metadata
  md <- read_deployment_yaml(input_paths$metadata)

  # Read data from file
  d <-  readr::read_csv(file = input_paths$data, show_col_types = FALSE) |>
    clean_csv_import_names()

  d$Date_Time <- format_csv_date_time(d$Date_Time)

  # Record logging interval in minutes
  t <- d$Date_Time[1:6]
  intervals <- (t[2:6]  - t[1:5]) |> as.numeric(units = "mins")
  if(!all(intervals == intervals[1])) {
    stop(input_paths$data, " appears to have a varying interval")
  }
  md$logging_interval_min <- intervals[1]

  d$Date_Time <- as.character(d$Date_Time)

  # Other information
  md$site <- paths$site
  md$deployment <- paste0(paths$site, "_", paths$deployment_date)
  md$deployment_date <- as.character(paths$deployment_date)
  md$auto_qc_date <- lubridate::today() |> as.character()



  # Check for consistancy in start and end times
  if(md$calibration_start != as.character(d$Date_Time[1]))
    stop("Inconsistent start times.")

  if(md$calibration_end != as.character(d$Date_Time[nrow(d)]))
    stop("Inconsistent end times.")


  # Calculate the ratio between calibrartion value from YSI ("TRUTH") to
  #  the uncalibrated logger value
  # Create placeholder items which will be filled in later
  md$pct_calibrated <- NA
  md$pct_immediate_rejection <- NA
  md$pct_flagged_for_review <- NA
  md$n_records <- NA
  md$do_deployment <- NA
  md$cond_deployment <- NA

  # Fill in NA for calibration ratios if they aren't provided
  if(!"start_ratio" %in% names(md$do_calibration))
    md$do_calibration$start_ratio <- NA
  if(!"end_ratio" %in% names(md$do_calibration))
    md$do_calibration$end_ratio <- NA


  # For debugging: cat(yaml::as.yaml(md))

  #============================================================================#
  # Process data
  #============================================================================#

  # Subset to expected columns
  final_names <- get_expected_columns("calibrated", names(d))
  if (!"Salinity" %in% names(d)) {
    stop("Salinity input column missing in CSV file.")
  }
  # This is a hack for MX801 or other data streams that don't have two
  # version of salinity, to make the output compatible with the original
  # processing which included two salinity data sets
  if(!"Salinity_DOLog" %in% names(d)) {
    d$Salinity_DOLog <- d$Salinity
  }

  if (!all(final_names %in% names(d))) {
    stop("Some required input columns missing from CSV:\n\t",
         paste(setdiff(final_names, names(d)), collapse = ",\n\t"))
  }

  d <- d[, final_names]




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


  return(list(d = d, md = md))

}
# nolint end: cyclocomp_linter
