# Immediate Rejection checks
# These all have the naming convention of ir_check_<data_col>()
# Any flags returned here will lead to immediate rejection


# Immediate Rejection check for temperature
# t: temperature sequence
# logger: logger letter designation for flag, either "D" (DO) or "C" (Cond.)
ir_check_temperature <- function(t, logger) {

  stopifnot(logger %in% c("D", "C"))

  flag <- rep("", length(t))

  sv <- t == bbp$logger_error_value & !is.na(t) # selection vector
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

  sv <- c == bbp$logger_error_value & !is.na(c)    # sv = selection vector
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

  sv <- d == bbp$logger_error_value
  flag[sv] <- paste0(flag[sv], "Re")

  sv <- d > bbp$max_raw_do
  flag[sv] <-  paste0(flag[sv], "Rh")

  flag
}
