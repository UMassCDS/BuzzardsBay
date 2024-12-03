# Immediate Rejection checks
# These all have the naming convention of ir_check_<data_col>()
# Any flags returned here will lead to immediate rejection


# Immediate Rejection check for temperature
# t: temperature sequence
# logger: logger letter designation for flag, either "D" (DO) or "C" (Cond.)
ir_check_temperature <- function(t, logger) {

  stopifnot(logger %in% c("D", "C"))

  flag <- rep("", length(t))

  sv <- t %in% bbp$logger_error_values & !is.na(t) # selection vector
  flag[sv] <- paste0(flag[sv], "T", logger, "e:") # sensor error indicated

  sv <- t < bbp$min_temp & !is.na(t)
  flag[sv] <- paste0(flag[sv], "T", logger, "l:") # low

  sv <- t > bbp$max_temp  & !is.na(t)
  flag[sv] <- paste0(flag[sv], "T", logger, "h:") # high
  return(flag)
}


# Immediate Rejection check for conductivity high range
ir_check_high_range <- function(c) {
  flag <- rep("", length(c))

  sv <- c %in% bbp$logger_error_values & !is.na(c)    # sv = selection vector
  flag[sv]  <- paste0(flag[sv], "He:")  # Error

  sv <- c < bbp$min_hr & !is.na(c)
  flag[sv] <- paste0(flag[sv], "Hl:") # Low

  sv <- c > bbp$max_hr & !is.na(c)
  flag[sv] <- paste0(flag[sv], "Hh:") # High
  return(flag)
}


# Immediate rejection check for raw dissolved oxygen
ir_check_raw_do <- function(d, interval = 0.25) {
  flag <- rep("", length(d))

  sv <- d %in% bbp$logger_error_values
  flag[sv] <- paste0(flag[sv], "Re:")

  sv <- d > bbp$max_raw_do
  flag[sv] <-  paste0(flag[sv], "Rh:")

  flag
}

# Immediate rejection check for sensor error codes
# Note this can be applied to any data column so the prefix used in the
# flag for the column it is called on should be specified.
# Arguments:
#  x: is the data as a vector
#  prefix: is the prefix used to describe the data column in the flags
ir_check_sensor_error <- function(x, prefix) {
  valid_prefix <- c("TD", "TC", "H", "R", "D", "P", "S")


  if (!prefix %in% valid_prefix) {
    stop("The data prefix (", prefix, ") should be one of: ",
         paste(valid_prefix, collapse = ", "), sep = "")
  }

  flag <- rep("", length(x))
  sv <- x %in% bbp$logger_error_values
  flag[sv] <- paste0(prefix, "e:")
  return(flag)
}
