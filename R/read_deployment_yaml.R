#' Read deployment metadata from a YAML file
#'
#' This is used by import types 0 (CSV) and 2 (MX801 excel file) to
#' read an accompanying YAML file and format into standard metadata list
#'
#' @param file The YAML file path
#' @param mx801  Set to TRUE when importing for MX801 which has slightly
#' different requirements
#' @returns Standardized metadata list
#' @keywords internal
read_deployment_yaml <- function(file, mx801 = FALSE)  {


  # From HOBOware Details.txt files
  md <- yaml::read_yaml(file)

  # Define list of expected input md items
  # TRUE indicates required items,
  # FALSE is for optional items
  # Inputs not on this list will be dropped
  # nolint start: indentation_linter
  expected_input_md_items <-
    list(
      site = FALSE,  # Can be filled in later
      deployment = FALSE, # Can be filled in later
      deployment_date = FALSE, # Can be filled in later
      calibration_start = TRUE, # AKA start of deployment
      calibration_end = TRUE,  # AKA end of deployment
      # pct_calibrated  # Calculated later
      # n_records  # Calculated later
      # pct_immediate_rejection # later
      # pct_flagged_for_reviers # later
      # logging_interval_min # later
      timezone = TRUE, # use "EST" or "GMT-04:00"
      # auto_qc_date # later
      do_calibration = list(n_points = FALSE,  # MX801
                            pct_saturation = FALSE,
                            measured_do = FALSE,
                            temperature = FALSE,
                            barometric_pressure = FALSE,
                            start_do_conc = FALSE, # older loggers
                            start_temperature_c = FALSE,
                            start_salinity_ppt = FALSE,
                            start_meter_titration_value_mg_l = FALSE,
                            start_salinity_correction = FALSE,
                            end_do_conc = FALSE,
                            end_temperature_c = FALSE,
                            end_meter_titration_value_mg_l = FALSE,
                            start_ratio = FALSE,
                            end_ratio = FALSE),
      do_deployment = list( # List for old devices, NA for MX801
        full_series_name = FALSE,
        launch_name = FALSE,
        launch_time = FALSE,
        calibration_date = FALSE,
        calibration_gain = FALSE,
        calibration_offset = FALSE),
      do_device = list(product = FALSE,
                       serial_number = TRUE,
                       version = FALSE),

      cond_calibration = list(
        date = FALSE,
        n_points = FALSE,
        spec_cond_25c = FALSE,
        measured_cond = FALSE,
        temperature = FALSE,
        calibration_points = FALSE,
        start_cal_cond = FALSE,
        start_cal_temp = FALSE,
        end_cal_cond = FALSE,
        end_cal_temp = FALSE),
      cond_deployment = list(
        full_series_name = FALSE,
        launch_name = FALSE,
        launch_time = FALSE),
      cond_device = list(product = FALSE,
                         serial_number = TRUE,
                         version = FALSE,
                         version_number = FALSE,
                         header_created = FALSE)
    )
  # nolint end
  # Add in optional top level sublists as empty elements if missing
  optional_top_lists <- c("cond_deployment", "cond_calibration",
                          "do_deployment", "do_calibration")



  if (mx801) {
    # Drop separate device requirements for mx801
    optional_top_lists <- c(optional_top_lists, "do_device", "cond_device")
    expected_input_md_items$cond_device$product <- FALSE
    expected_input_md_items$cond_device$serial_number <- FALSE
    expected_input_md_items$do_device$product <- FALSE
    expected_input_md_items$do_device$serial_number <- FALSE
    expected_input_md_items$serial_number <- TRUE

  }

  missing_top_lists <- setdiff(optional_top_lists, names(md))
  if (length(missing_top_lists) > 0) {
    miss <- vector(mode = "list", length = length(missing_top_lists))
    names(miss) <- missing_top_lists
    md <- c(md, miss)
  }

  # Check for missing items and eliminate inputs that aren't allowed
  md <- md[names(md) %in% names(expected_input_md_items)]

  for (i in seq_along(expected_input_md_items)) {
    n <- names(expected_input_md_items)[i]
    expected_item <- expected_input_md_items[[n]]

    md_item <- md[[n]]
    if (is.list(expected_item)) {
      if (!n %in% names(md)) {
        stop("Expected top level item: \"", n,
             "\" missing from YAML file:\n\t", file, "",
             sep = "")

      }
      for (j in seq_along(expected_item)) {
        inner_name <- names(expected_item)[j]
        if (expected_item[[j]] && !inner_name %in% names(md_item)) {
          stop("Required sub-element \"", inner_name, "\" missing from ", n,
               "in: ", file)
        } # end if required inner item missing
      } # end loop through sub-list

      # Eliminate extra sublist items
      if (is.list(md_item)) {
        md_item <- md_item[names(md_item) %in% names(expected_item)]
        md[[n]] <- md_item
      }

    } else {
      # Not a list, will be logical indicating if it's required
      if (expected_item && !n %in% names(md)) {
        stop("Expected top level item:", n,
             "missing from YAML file:\n\t", file, "")
      } # end missing required top level item
    } # end else

  } # end item loop

  # Create placeholder items which will be filled in later
  md$pct_calibrated <- NA
  md$n_records <- NA
  md$pct_immediate_rejection <- NA
  md$pct_flagged_for_review <- NA
  md$logging_interval_min <- NA

  # Convert serial_number to DO and Cond device serial numbers for
  # consistency with original metadata format
  if (mx801) {
    md$cond_device$serial_number <- md$serial_number
    md$do_device$serial_number <- md$serial_number
    md$serial_number <- NULL # drop from list
  }

  return(md)
}
