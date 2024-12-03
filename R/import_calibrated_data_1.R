# nolint start: cyclocomp_linter
import_calibrated_data_1 <- function(paths) {

  # This is for data format type 1 which has separate HOBOware CSV and
  # details.txt files for the Dissolved Oxygen and Conductivity Sensors.

  placements <- read_and_format_placements(paths$placements)

  # Set input calibration data paths
  l <- list.files(paths$deployment_cal_dir, full.names = TRUE)
  l <- gsub("[/\\\\]+", .Platform$file.sep, l)

  input_paths = list(
    do = grep("DO_[^/]*\\.csv$", l, value = TRUE, ignore.case = TRUE),
    cond = grep("(Cond*|Sal)_[^/]*\\.csv$", l, value = TRUE, ignore.case = TRUE),
    do_details = grep("DO_[^/]*details\\.txt$", l, value = TRUE,
                      ignore.case = TRUE),
    cond_details = grep("(Cond*|Sal)_[^/]*details\\.txt$", l, value = TRUE,
                        ignore.case = TRUE))

  # Check that we found 1 and only 1 of each type of file in the calibration dir
  has_one <- sapply(input_paths, length) == 1
  if(!all(has_one)){
    stop("Couldn't find required files in calibration dir: ",
         paste(names(input_paths)[!has_one], collapse = ", "))
  }

  # Add year specific site and placement file paths to input paths
  input_paths <- c(input_paths, list(
    sites = paths$sites,
    placements = paths$placements
  ))

  # Print input paths:

  # Convert input files to relative paths (for printing)
  relative_paths  <- input_paths |> unlist() |> as.character()
  relative_paths <- gsub(paste0("^", paths$base_dir, "[/\\\\]*"), "",
                         relative_paths, ignore.case = TRUE)

  cat("\nImporting calibrated data Type 1 - Hoboware CSV and datails.txt\n",
      "\twith import_calibrated_data_1()\n\n")

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


  #============================================================================#
  # Process Metadata                                                        ####
  #============================================================================#

  # From HOBOware Details.txt files
  md <- c(get_do_details(input_paths$do_details),
          get_cond_details(input_paths$cond_details))

  # Check for salinity calibration based on a single value -rather than file -
  # which indicates that the salinity data is bad
  bad_salinity_data <- "salinity_value_ppt" %in% names(md$do_calibration)


  # Consolidate information from the two devices

  # Format timezone
  a <- md$do_device$header_created
  do_tz <- gsub("^.*(GMT-[[:digit:]]+:[[:digit:]])", "\\1", a)
  a <- md$cond_device$header_created
  cond_tz <-  gsub("^.*(GMT-[[:digit:]]+:[[:digit:]])", "\\1", a)
  stopifnot(do_tz == cond_tz)
  md$timezone <- do_tz
  rm(a, cond_tz, do_tz)

  # Deployment interval (minutes)
  do_interval <- md$do_deployment$logging_interval_min
  cond_interval <- md$cond_deployment$logging_interval_min
  if(!do_interval == cond_interval)
    stop("The logging interval for the two devices does not match. DO: ",
         do_interval, " min, Cond: ", cond_interval, sep = " min")
  md$logging_interval_min <- do_interval
  md$do_deployment$logging_interval <- NULL
  md$do_deployment$logging_interval_min <- NULL
  md$cond_deployment$logging_interval <- NULL
  md$cond_deployment$logging_interval_min <- NULL

  # Other information
  md$site <- paths$site
  md$deployment <- paste0(paths$site, "_", paths$deployment_date)
  md$deployment_date <- as.character(paths$deployment_date)
  md$auto_qc_date <- lubridate::today() |> as.character()

  # Process calibration start times
  # Note one but not both calibration times might be NA due to single point
  # calibration
  ds <- md$do_calibration$start_time
  cs <- md$cond_calibration$start_cal_time
  # Check for consistancy
  if(!is.na(ds) && !is.na(cs)  && ds != cs)
    stop("Calibration start times don't match in details files.")
  # Consolidate start time - using whichever value isn't NA (if one is)
  md$calibration_start <- ifelse(is.na(ds), cs, ds)
  md$do_calibration$start_time <- NULL
  md$cond_calibration$start_cal_time <- NULL
  rm(ds, cs)

  # Process calibration end times
  de <- md$do_calibration$end_time
  ce <- md$cond_calibration$end_cal_time
  if(!is.na(de) && !is.na(ce) && de != ce)
    stop("Calibration end times don't match in details files.")
  # Consolidate end time - using whichever value isn't NA (if one is)
  md$calibration_end <- ifelse(is.na(de), ce, de)
  md$do_calibration$end_time <- NULL
  md$cond_calibration$end_cal_time <- NULL
  rm(de, ce)

  # Reformat date time items in dt to <year>-<month>-<day> h:m:s
  dt_items <- list(
    c("calibration_start"),
    c("calibration_end"),
    c("do_deployment", "launch_time"),
    c("do_deployment", "calibration_date"),
    c("do_device", "header_created"),
    c("cond_deployment", "launch_time"),
    c("cond_device", "header_created")
  )
  for(item in dt_items){
    md[[item]] <- format_date_time(md[[item]])
  }

  # Calculate the ratio between calibrartion value from YSI ("TRUTH") to
  #  the uncalibrated logger value

  # DO Ratio
  md$do_calibration$start_ratio <-
    md$do_calibration$start_meter_titration_value_mg_l /
    md$do_calibration$start_do_conc

  md$do_calibration$end_ratio <-
    md$do_calibration$end_meter_titration_value_mg_l /
    md$do_calibration$end_do_conc

  # Conductivity Ratio
  # NOTE: Conductivity calibration ratios have not been calculated yet!!!

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
  stopifnot(all(md_order %in% names(md)))

  md <- md[md_order]


  # For debugging: cat(yaml::as.yaml(md))

  #============================================================================#
  # Process data
  #============================================================================#

  #----------------------------------------------------------------------------#
  # Read and Process Calibrated DO and Conductivity Tables                  ####
  #----------------------------------------------------------------------------#

  # Read tabular data
  do <- readr::read_csv(input_paths$do, col_types = readr::cols(),
                        show_col_types = FALSE)
  cond <- readr::read_csv(input_paths$cond, col_types = readr::cols(),
                          show_col_types = FALSE)

  # Extract serial number
  do_sn <- get_logger_sn(do)
  cond_sn <- get_logger_sn(cond)

  # Note some files don't have SN in the column heading anymore
  # First noticed with "OB1/2024-05-31 Cond file
  if(is.na(do_sn)) do_sn <- md$do_device$serial_number
  if(is.na(cond_sn)) cond_sn <- md$cond_device$serial_number

  # Verify serial numbers
  if(do_sn != md$do_device$serial_number)
    stop("DO Serial number in csv does not match serial number in Details.txt")
  if(cond_sn != md$cond_device$serial_number)
    stop("Cond Serial number in csv does not match serial number in ",
         "Details.txt")

  # Check SN against placements
  check_placement(do_sn, type = "DO", placements,
                  paths$deployment_date,
                  paths$site)
  check_placement(cond_sn, type = "Cond", placements,
                  paths$deployment_date,
                  paths$site)

  # Preliminary column name cleanup
  do <- clean_logger_header(do)
  cond <- clean_logger_header(cond)

  # Double check for bad salinity data (previously checked based on metadata)
  # If DO is missing "Salinity" column it was calibrated with a fixed salinity
  # indicating bad salinity data.
  if(!"Salinity" %in% names(do))
    bad_salinity_data <- TRUE

  if(!bad_salinity_data)
    do <- dplyr::rename(do, Salinity_DOLog = "Salinity")

  # Rename identical columns to avoid name collisions
  do <- dplyr::rename(do, Temp_DOLog = "Temp")
  cond <- dplyr::rename(cond, Temp_CondLog = "Temp")

  if (bad_salinity_data) {
    # If the salinity data is not trustworthy replace it with NA
    do$Salinity_DOLog <- NA
    cond$Salinity <- NA
    cond$Spec_Cond <- NA
    cond$High_Range <- NA
  }

  # Identify and rename salinity column (This si for robustness)
  salinity_col <- grep("^Salinity", names(cond), value = TRUE)
  if(length(salinity_col) == 0)
    stop("Could not find a salinity column in ", input_paths$cond)
  if(length(salinity_col) > 1)
    stop("Found multiple salinity columns in ", input_paths$cond)
  names(cond)[names(cond) == salinity_col] <- "Salinity"

  # rename "DO_Pct" to "DO_Pct_Sat"
  # The 2022 data had "Sat" 2023 did not.  I want to work with both
  names(do)[names(do) == "DO_Pct"] <- "DO_Pct_Sat"

  # Merge
  d <- dplyr::full_join(do, cond, by = "Date_Time")

  # Rename "DO" to "Raw_DO", and "DO_Adj" to "DO"
  names(d)[names(d) == "DO"] <- "Raw_DO"
  names(d)[names(d) == "DO_Adj"] <- "DO"

  # Convert date time to string in the format yyyy-mm-dd h:m:s
  # Convert Date_Time to POSIXct date time class
  d$Date_Time <- lubridate::mdy_hms(d$Date_Time) |>
    format(format = "%Y-%m-%d %H:%M:%S")


  # Verify that the two Salinities are identical
  if(!all(d$Salinity == d$Salinity_DOLog | is.na(d$Salinity)))
    stop("The salinity column from the calibrated DO CSV file should ",
         "match the salinity column from the calibrated Conductivity file, but they don't.")


  return(list(d = d, md = md))

}
# nolint end: cyclocomp_linter
