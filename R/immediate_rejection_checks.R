# Immediate Rejection checks
# These all have the naming convention of ir_check_<data_col>()
# Any flags returned here will lead to immediate rejection


# Immediate Rejection check for temperature
# t: temperature sequence
# logger: logger letter designation for flag, either "D" (DO) or "C" (Cond.)
ir_check_temperature <- function(t, logger) {

  stopifnot(logger %in% c("D", "C"))

  flag <- rep("", length(t))

  sv <- t == -888.88 & !is.na(t) # selection vector
  flag[sv] <- paste0(flag[sv], "T", logger, "e:") # sensor error indicated

  sv <- t < 5 & !is.na(t)
  flag[sv] <- paste0(flag[sv], "T", logger, "l:") # low

  sv <- t > 35  & !is.na(t)
  flag[sv] <- paste0(flag[sv], "T", logger, "h:") # high
  return(flag)
}


# Immediate Rejection check for conductivity high range
ir_check_high_range <- function(c) {
  flag <- rep("", length(c))

  sv <- c == -888.88 & !is.na(c)    # sv = selection vector
  flag[sv]  <- paste0(flag[sv], "He:")  # Error

  sv <- c < 1000 & !is.na(c)
  flag[sv] <- paste0(flag[sv], "Hl:") # Low

  sv <- c > 55000 & !is.na(c)
  flag[sv] <- paste0(flag[sv], "Hh:") # High
  return(flag)
}


# Immediate rejection check for raw dissolved oxygen
ir_check_raw_do <- function(d, interval = 0.25) {
  flag <- rep("", length(d))

  sv <- d == -888.88
  flag[sv] <- paste0(flag[sv], "Re")

  sv <- d > 20
  flag[sv] <-  paste0(flag[sv], "Rh")

  flag
}
