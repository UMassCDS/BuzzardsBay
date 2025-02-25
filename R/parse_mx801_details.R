# nolint start: line_length_linter
#' Extract specific metadata items from the MX801 details sheet
#'
#' This it a internal helper function to extract MX801 details (metadata)
#' from the third sheet of an Excel file.
#'
#' `parse_mx801_details()` is kludgy because the data
#' is written into the details file in a fairly haphazard way.
#'
#' The approach is to do a bunch of formatting of the text from the
#' details file to make it somewhat YAML like, to parse as YAML, and then
#' to do a little more cleanup and extraction.
#'
#' * [description of the output metadata fields](https://docs.google.com/document/d/1GKw3eq9ALigEcX_AWl4vnlejSzsTiIVHzy6LoKCR1jw).
#'
#'
#' @param file The path to the calibrated Excel (`.xlsx`) file from the
#' MX801 logger
#'
#' @returns A nested list with selected metadata from the details
#
#' @examples
#' # parse_mx801_details() is an internal function so example code will
#' # only work after devtools::load_all()
#' \dontrun{
#'
#' p <- setup_example_dir(site_filter = "BBC", year_filter = 2025,
#'  deployment_filter = "2025-01-04")
#' f <- list.files(file.path(p$deployment, "Calibrated"),
#'                 pattern =  ".xlsx$", full.names  = TRUE )
#' md <- parse_mx801_details(f)
#' yaml::as.yaml(md) |> cat(sep = "\n")
#' }
#' @keywords internal
# nolint end
parse_mx801_details <- function(file) {

  stopifnot(file.exists(file))
  md <- list() # metadata list object to be populated

  #----------------------------------------------------------------------------#
  # Process into nested list
  #----------------------------------------------------------------------------#
  # Note each row in the details tab has one non-empty cell in one of the
  # first four columns.
  # Here we reformat the data as text with indentations indicating column
  # then we precede everything that is indented with a dash,
  # delete all but the first colon on every line.
  # Add a trailing colon on lines that would otherwise
  # Add null after a colon if the next line doesn't have additional indentation
  # Delete all but the last colon on every line.
  # And convert to a list with read_yaml()


  d <- readxl::read_excel(file, sheet = 3, col_types = "text",
                          col_names = FALSE)
  d2 <- lapply(d, function(x) paste0(x, ":")) |> as.data.frame()

  restore_na <- function(x) {
    x[grepl("^NA:$", x)] <- NA
    x
  }

  d3 <- lapply(d2, restore_na)  |> as.data.frame()

  indent_na <- function(x) {
    x[is.na(x)] <- "  "
    x
  }

  d4 <- lapply(d3, indent_na) |> as.data.frame()

  # drop trailing ":" in last column
  last <- ncol(d4)
  d4[, last] <- gsub(":$", "", d4[, last])

  # Convert each row into a string
  text <- apply(d4, 1, function(x) paste(x, collapse = ""))

  # Dropping first line ("Details") because it breaks list hierarchy
  text <- text[-1]

  # Drop trailing white space
  text <- gsub("[[:blank:]]*$", "", text)

  ### Indentation problems
  # If a line ends in a colon than the next line should be indented more
  # Here we add a "NA" after the colon if that's not true so that the
  # item has a value - necessary to parse as YAML
  indentation <- gsub("^( *)[^ ].*$", "\\1", text, perl = TRUE) |> nchar()
  next_line_indented <- indentation < c(indentation[-1], NA)
  next_line_indented[is.na(next_line_indented)] <- FALSE
  ends_in_colon <- grepl(":[[:blank:]]*$", text)
  indentation_problems <-   ends_in_colon & !next_line_indented
  # Resolve indentation problems by adding "NA" to end of line.
  text[indentation_problems] <- paste0(text[indentation_problems], "NA")


  # Some cells have internal \r or \n carriage returns
  # For those cells we are going to split at the first :
  # and each carriage return and then indent everything but the first
  # item with the indentation of the first item + "  "
  # This turns each line in the cell into a list item.

  l <- strsplit(text, "(\r)|(\n)|(\r\n)")
  multi <- which(unlist(lapply(l, length)) > 1)
  for (i in multi) {
    vect <- l[[i]]
    padding <- gsub("(^[[:blank:]]+).*$", "\\1", vect[1], perl = TRUE)
    padding <- paste(padding, "  ")
    # split first element at :
    first <- vect[1]
    first_of_first <- gsub("(^[^:]*:).*$", "\\1", first)
    rest_of_first <- gsub("^[^:]*:", "", first)
    vect <- c(first_of_first, rest_of_first, vect[-1])

    others <- setdiff(seq_along(vect), 1)
    vect[others] <- paste0(padding, gsub("^[[:blank:]]+", "", vect[others]))
    l[[i]] <- vect
  }
  text <- unlist(l)


  # Add leading - for all indented items
  text <- gsub("(^[[:blank:]]{6})", "\\1- ", text)

  ### Double colon problems
  # A line should only have one colon
  # Drop first colon if there are two
  # But don't process times as they aren't a problem

  # Temporarily replace time colons with semicolons
  text <- gsub("([[:digit:]]+):([[:digit:]]+):([[:digit:]])+",
               "\\1;\\2;\\3", text)

  # Clean up duplicated colons:
  while (any(grepl(":.*:", text))) {
    text <- gsub(":(.*:)", "\\1", text, perl = TRUE)
  }
  # Insert spaces after all :
  text <- gsub(":[[:blank:]]*", ": ", text)

  # Restore time colons
  text <- gsub("([[:digit:]]+);([[:digit:]]+);([[:digit:]]+)",
               "\\1:\\2:\\3", text)

  # Cleanup duplicated "Measured Dissolved Oxygen"
  # by adding a sequence number " 1", " 2" etc.
  # yml doesn't allow duplicated list item names
  # Adding "_1" even if there's only one for consistency
  mdo_lines <- grep("Measured Dissolved Oxygen", text)
  for (i in seq_along(mdo_lines)) {
    mdo_line <- mdo_lines[i]
    text[mdo_line] <- gsub("Measured Dissolved Oxygen",
                           paste0("Measured Dissolved Oxygen ", i),
                           text[mdo_line])

  }


  # Convert to yaml and clean recursively the list names and eliminate some
  # oddities in the resulting list
  l <- yaml::read_yaml(text = text)
  l <- clean_names(l)
  l <- simplify_list(l)


  #----------------------------------------------------------------------------#
  #
  # Extract specific items
  #
  #----------------------------------------------------------------------------#


  # Process device information
  md$do_device$product <- l$Devices$Device_Info$Product
  md$do_device$serial_number <- l$Devices$Device_Info$Serial_Number
  md$do_device$version <- l$Devices$Device_Info$Firmware_Version
  md$cond_device <- md$do_device  # same device for do and cond


  # Extract DO Series Information

  # The slightly odd thing here is that there are variable numbers of
  # calibration points and the value of each corresponds to a preceding
  # pct_saturation line which might be several lines earlier or immediately
  # preceding.
  # I'm extracting and storing both
  # Pct_Saturation and Measured_DO as vectors - one for each calibration point

  i <- grep("Series_Measured_DO", names(l))
  if (length(i) != 1)
    stop("Could not find the Series_Electrical_Conductivity header",
         " in the details sheet")
  names(l)[i] <-  "Series_Measured_DO"

  if (!"DO_Percent_Saturation_Calibration" %in% names(l$Series_Measured_DO)) {
    stop("Expected to fine DO_Percent_Saturation_Calibration ",
         "within Series_Measured_DO in the details sheet")
  }
  do_cal <- l$Series_Measured_DO$DO_Percent_Saturation_Calibration

  extract_number <- function(x) {
    # Note extract_number() expects the number to be at the start of the string
    gsub("^([-.[:digit:]]+)[^-.[:digit:]]*$", "\\1", x) |>
      as.numeric()
  }

  saturation_i <- grep("[[:digit:]]+pct_Saturation", names(do_cal))
  saturation_pct <- extract_number(names(do_cal)[saturation_i])
  measured_do_i <- grep("^Measured_Dissolved_Oxygen", names(do_cal))
  measured_do_vals <- extract_number(do_cal[measured_do_i])
  cal_temp <- do_cal[[grep("Temperature", names(do_cal))]] |> extract_number()
  pressure <- do_cal[[grep("Barometric_Pressure", names(do_cal))]] |>
    extract_number()

  md$do_calibration  <- list(n_points = length(saturation_pct),
                             pct_saturation = saturation_pct,
                             measured_do = measured_do_vals,
                             temperature = cal_temp,
                             barometric_pressure = pressure,
                             start_ratio = NA,
                             end_ratio = NA)

  # Timezone
  dt <-  l$Series_Measured_DO$Series_Statistics$First_Sample_Time
  md$timezone <- gsub("^.*[[:blank:]]+", "", dt) # from last blank to end



  # Process Electrical Conductivity
  i <- grep("Series_Electrical_Conductivity", names(l))
  if (length(i) != 1)
    stop("Could not find the Series_Electrical_Conductivity header in the ",
         "details sheet")
  names(l)[i] <- "Series_Electrical_Conductivity"

  cond <- l$Series_Electrical_Conductivity

  # Save conductivity calibration information
  cc <- list() # will be md$cond_calibration
  cc$date <-
    cond$Channel_Parameters$Conductivity_Calibration_Date |>
    lubridate::ymd_hms() |>
    as.character()
  calibration_pt_i <- grep("Calibration_Point", names(cond$Channel_Parameters))
  cc$n_points <- length(calibration_pt_i)
  cc$spec_cond_25c <- numeric(0)
  cc$measured_cond <- numeric(0)
  cc$temperature <- numeric(0)
  for (i in calibration_pt_i) {
    cat(i, "\n")
    cp <- cond$Channel_Parameters[[i]]
    cc$spec_cond_25c <- c(cc$spec_cond_25c,
                          cp$Specific_Conductance_at_25C |> extract_number())
    cc$measured_cond <- c(cc$measured_cond,
                          cp$Measured_Specific_Conductance |> extract_number())
    cc$temperature <-  c(cc$temperature, cp$Temperature |> extract_number())
  }

  md$cond_calibration  <- cc


  # Start and end of deployment
  # note these are legacy labels in that for the first data flow
  # calibration happened in the field and marked the start and end of
  # the deployment
  md$calibration_start <-
    l$Series_Measured_DO$Series_Statistics$First_Sample_Time |>
    lubridate::ymd_hms() |>
    as.character()
  md$calibration_end <-
    l$Series_Measured_DO$Series_Statistics$Last_Sample_Time |>
    lubridate::ymd_hms() |>
    as.character()
  md$deployment_date <-
    l$Series_Measured_DO$Series_Statistics$Last_Sample_Time |>
    lubridate::ymd_hms() |>
    lubridate::as_date() |>
    as.character()

  return(md)
}
