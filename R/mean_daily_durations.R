#' Give mean duration of low-DO runs in hours
#'
#' Returns means of runs of DO below the specified threshold in hours. Days (noon-noon) with DO
#' above the threshold are excluded. We use noon to noon as most low-DO runs typically start
#' in the evening. Multiple day-runs are included in the means. Runs of 6 or fewer NAs surrounded
#' by DO below the threshold are treated as below the threshold.
#'
#' @param x A data frame with three columns:
#' 1. `x` Data frame with Date, Date_Time, and DO
#' 2. `threshold` Low-DO threshold
#' @return Mean length of low-DO runs for days with low DO, in hours
#' @keywords internal


mean_daily_durations <- function(x, threshold) {

   x$Date_Time <- as.POSIXct(x$Date_Time)
   x$Date <- date(x$Date_Time + dhours(12))                                               # shift 12 hours to use noon-noon days
   x <- x[x$Date %in% x$Date[x$DO < threshold & !is.na(x$DO)], ]                          # we only care about days that fall below threshold at some point

   if(all(x$DO >= threshold))
      return(0)

   x$trigger <- replace_na_runs(x$DO < threshold, max_run = 6, boundary = FALSE)          # runs of <= threshold NA surrounded by TRUE become TRUE; others FALSE. Don't assume TRUE beyond data.
   r <- cumsum(x$trigger & !c(FALSE, x$trigger[-length(x$trigger)])) * x$trigger
   r[r == FALSE] <- c(FALSE, r[-length(r)])[r == FALSE]                                   # extend run by 1 sample to get proper periods (1st below threshold to 1st above)
   d <- cbind(start = aggregate(x$Date_Time, by = list(r), FUN = 'min'),
              end = aggregate(x$Date_Time, by = list(r), FUN = 'max'))                    # deltas in sec
   d <- d[d$start.Group.1 != 0,]                                                          # drop group 0

   z <- mean((lubridate::as.duration(d$end.x - d$start.x)) / dhours(1))                   # mean lenth of low-DO runs

   z
}
