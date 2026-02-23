
# Functions to run QC checks on data columns that result in a flag
# but not immediate rejection (see immediate_rejection_checks.R)
# These all take the form of check_<data_col>()

# Note depth is a little funky because it can throw a 7 which results in
# immediate rejection, and because it potentially adds flags to two columns.
# It is included here.

# Temperature
#  This is called both on the Dissolved O2 logger temperature and on the
#   Conductivity logger temperature.
#  x : temp seq.
#  logger : either "D" or "C" indicating which logger collected the
#    temperature.
# site : site code
# sites : site table
check_temperature <- function(x, logger, site, sites) {
  stopifnot(length(logger) == 1, logger %in% c("D", "C"))
  flag <- rep("", length(x))
  si <- which(sites$site == site)
  flag[x < sites$Min_QC_Temp[si]] <- paste0("T", logger, "sl:")
  flag[x > sites$Max_QC_Temp[si]] <- paste0("T", logger, "sh:")
  return(flag)
}

# Fouling flags for Raw DO
#  x : high range values
# site : site code
# sites : site table
check_raw_do <- function(x, site, sites) {
  flag <- rep("", length(x))
  si <- which(sites$site == site)
  flag[x < sites$Min_QC_Raw_DO[si]] <- "Rsl:"
  flag[x > sites$Max_QC_Raw_DO[si]] <- "Rsh:"
  return(flag)
}



# Fouling flags for calibrated dissolved oxygen
# interval: interval between observations in minutes
check_do <- function(x, interval = 15, site, sites) {


  # Set number of sequential observations that are "more than an hour"
  # Document indicates greater than 1 hour so with 15 minute
  # interval that means 5 observations
  # with 10 minute intervals it will be 7
  n <- ceiling(bbp$do_streak_duration / interval) + 1

  #----------------------------------------------------------------------------#
  # Low streak
  # Check for more than an hour below do_streak_min
  #----------------------------------------------------------------------------#

  end_of_streak <-
    slider::slide_vec(x, .before = n - 1,
                      .f = function(x) all(x < bbp$do_streak_min),
                      .complete = TRUE)
  end_of_streak[is.na(end_of_streak)] <- FALSE

  # Expand flag to catch all the values that were in the streak
  in_low_streak <- slider::slide_vec(end_of_streak, .after = n - 1, .f = any)
  in_low_streak[is.na(in_low_streak)] <- FALSE

  #----------------------------------------------------------------------------#
  # Big Jumps
  #----------------------------------------------------------------------------#

  diff <- x - c(x[-1], NA)
  start_of_jump <- abs(diff) > bbp$do_max_jump & !is.na(diff)
  # Capture end of jump too:
  big_jump <- start_of_jump | c(FALSE, start_of_jump[-length(start_of_jump)])

  #----------------------------------------------------------------------------#
  # Low variation
  #----------------------------------------------------------------------------#
  n <- ceiling(bbp$do_lv_duration / interval) + 1
  low_var <- has_low_variation(x, max_range = bbp$do_lv_range, n = n)

  #----------------------------------------------------------------------------#
  # High or low for site
  #----------------------------------------------------------------------------#
  si <- which(sites$site == site) # site index
  low_for_site <- x < sites$Min_QC_DO[si] & !is.na(x)
  high_for_site <- x > sites$Max_QC_DO[si] & !is.na(x)


  #----------------------------------------------------------------------------#
  # Set flags
  #----------------------------------------------------------------------------#


  flag <- rep("", length(x))
  flag[low_var] <- paste0(flag[low_var], "Dlv:")
  flag[big_jump] <- paste0(flag[big_jump], "Dj:")
  flag[in_low_streak] <- paste0(flag[in_low_streak], "Dls:")
  flag[low_for_site] <- paste0(flag[low_for_site], "Dsl:")
  flag[high_for_site] <- paste0(flag[high_for_site], "Dsh:")

  return(flag)

}



check_salinity <- function(x, interval = 15, site, sites) {

  # Special case where salinity was bad and not used for calibration
  if (all(is.na(x)))
    return(rep("", length(x)))


  # Jumps
  diff <- c(x[-1], NA) - x
  end_of_jump <- abs(diff) > bbp$sal_max_jump & !is.na(diff)
  big_jump <- end_of_jump | c(FALSE, end_of_jump[-length(end_of_jump)])
  big_jump

  # Low variation
  n <- ceiling(bbp$sal_lv_duration / interval) + 1
  low_var <- has_low_variation(x,
                               max_range = bbp$sal_lv_range,
                               n)

  #----------------------------------------------------------------------------#
  # High or low for site
  #----------------------------------------------------------------------------#
  si <- which(sites$site == site) # site index
  low_for_site <- x < sites$Min_QC_Sal[si]
  high_for_site <- x > sites$Max_QC_Sal[si]

  #----------------------------------------------------------------------------#
  # Set flags
  #----------------------------------------------------------------------------#
  flag <- rep("", length(x))
  flag[big_jump] <- paste0(flag[big_jump], "Sj:")
  flag[low_var] <- paste0(flag[low_var], "Slv:")
  flag[low_for_site] <- paste0(flag[low_for_site], "Ssl:")
  flag[high_for_site] <- paste0(flag[high_for_site], "Ssh:")

  return(flag)
}


# Fouling flags for DO Percent Saturation
#  x : Do Pct. Sat. values
# site : site code
# sites : site table
check_do_pct_sat <- function(x, site, sites) {
  flag <- rep("", length(x))
  si <- which(sites$site == site)
  flag[x < sites$Min_QC_DO_Pct_Sat[si]] <- "Rsl:"
  flag[x > sites$Max_QC_DO_Pct_Sat[si]] <- "Rsh:"
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

# Check Depth
#  * If Depth is less than `min_depth` (defaults to 0) write 7 to `Depth_QC`,
#    add `Wl` flag, and write `91` in `GEN_QC`.
#  * If Depth is greater than `max_depth` (defaults to 9) write 7 to
#   `Depth_QC`, add `Wh` to flags, and write `9999` to `GEN_QC`
#  With regards to Gen_QC  which could be NA, 9, or 9999 due to other checks
#  *  A 91 from depth does NOT overwrite a 9999 from other flags
#  *  A 9999 from depth does NOT overwrite a 9 from other flags
#  *  A 91 from depth DOES overwrite a 9 from other flags
#  (Precedence is handled in qc_deployment() )
check_depth <- function(depth) {
  res <- data.frame(Depth_Flag = rep("", length(depth)),
                    Gen_QC = NA,
                    Depth_QC = NA)
  water_low <- depth < bbp$min_depth
  water_high <- depth > bbp$max_depth
  res$Depth_Flag[water_low] <- "Wl:"
  res$Gen_QC[water_low] <- 91

  res$Depth_Flag[water_high] <- "Wh:"
  res$Gen_QC[water_high] <- 9999

  res$Depth_QC[water_high | water_low] <- 7

  return(res)
}
