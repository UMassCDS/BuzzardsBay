
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



# Fouling flags for calibrated dissolved oxygen
# interval: interval between observations in minutes
check_do <- function(x, interval = 15, site, prior_flags = NULL) {

  ## Set parameters
  do_streak_min  <- 0.5 # Flag if DO is below this for more than an hour
  do_max_jump <- 2 # Flag if DO jumps by more than this between observations
  do_low_variation_max_range <- 0.01 # Flag if the range of observed values
  #  (max - min) stays below this number for an hour


  # Set number of sequential observations that are "more than an hour"
  # Document indicates greater than 1 hour so with 15 minute
  # interval that means 5 observations
  # with 10 minute intervals it will be 7
  n <- ceiling(60 / interval) + 1

  #----------------------------------------------------------------------------#
  # Low streak
  # Check for more than an hour below do_streak_min
  #----------------------------------------------------------------------------#

  end_of_streak <- slider::slide_vec(x,
                                     .before = n - 1,
                                     .f = function(x) all(x < do_streak_min),
                                     .complete = TRUE)

  # Expand flag to catch all the values that were in the streak
  in_low_streak <- slider::slide_vec(end_of_streak, .after = n - 1, .f = any)
  in_low_streak[is.na(in_low_streak)] <- FALSE

  #----------------------------------------------------------------------------#
  # Big Jumps
  #----------------------------------------------------------------------------#

  diff <- x - c(x[-1], NA)
  start_of_jump <- abs(diff) > do_max_jump & !is.na(diff)
  # Capture end of jump too:
  big_jump <- start_of_jump | c(FALSE, start_of_jump[-length(start_of_jump)])

  #----------------------------------------------------------------------------#
  # Low variation
  #----------------------------------------------------------------------------#

  low_var <- has_low_variation(x, max_range = do_low_variation_max_range, n = n)

  #----------------------------------------------------------------------------#
  # High or low for site
  #----------------------------------------------------------------------------#

  warning("Skipped flagging high and low Dissolved O2 for site.")


  # Set flags
  if (is.null(prior_flags)) {
    flags <- rep("", length(x))
  } else {
    flags <- prior_flags
  }
  flags[low_var] <- paste0(flags[low_var], "Dlv:")
  flags[big_jump] <- paste0(flags[big_jump], "Dj:")
  flags[in_low_streak] <- paste0(flags[in_low_streak], "Dls")

  return(flags)

}



check_salinity <- function(s, interval = 15, site) {

  ## Set parameters
  salinity_max_jump <- 0.75 # Flag if DO jumps exceed this between observations
  salinity_low_var_max_range <- 0.01 # Flag if the range of observed
  # values (max - min) stays below this number for an hour


  # Jumps
  diff <- c(s[-1], NA) - s
  end_of_jump <- abs(diff) > salinity_max_jump & !is.na(diff)
  big_jump <- end_of_jump | c(FALSE, end_of_jump[-length(end_of_jump)])
  big_jump

  # Low variation
  n <- ceiling(60 / interval) + 1
  low_var <- has_low_variation(s,
                               max_range = salinity_low_var_max_range,
                               n)

  # Out of site specific range
  #### PENDING

  warning("Skipped flagging high and low salinity for site.")

  # Set flags
  flag <- rep("", length(s))
  flag[big_jump] <- paste0(flag[big_jump], "Sj")
  flag[low_var] <- paste0(flag[big_jump], "Slv")

  return(flag)
}

has_low_variation <- function(x, max_range = 0.01, n = 5) {
  # Is each value in x part of a low variations streak of at least n values
  # that don't range by more than range

  range_too_small <- function(x) {
    r <- range(x)
    r <- r[2] - r[1]
    return(r < max_range)
  }

  end_of_low_streak <- slider::slide_vec(x,
                                         .before = n - 1,
                                         .f = range_too_small,
                                         .complete = TRUE)
  end_of_low_streak[is.na(end_of_low_streak)] <- FALSE

  low_var <- slider::slide_vec(end_of_low_streak, .after = n - 1, .f = any)
  return(low_var)
}
