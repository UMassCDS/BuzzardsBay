   #' Give duration of the longest run of low DO for each day
   #'
   #' Finds the longest run of DO below a threshold for each day.
   #'
   #' Looks into the previous day for the start of runs, as many low-DO events start in the
   #' evening. Reported durations are no longer than 24 hours.
   #'
   #' If trigger is all false for a day, the result is 0. If trigger is all NA
   #' for a day, the result is NA.
   #'
   #' @param x A data frame with three columns:
   #' 1. `Date` The date, in format 2024-05-30
   #' 2. `Date_Time` The date and time, in format 2024-05-30 16:20:00
   #' 3. `trigger` TRUE when DO is below the selected threshold (the name of this column varies)
   #' @return Length of the longest run of TRUEs in fractional hours
   #' @import stats
   #' @keywords internal
   # Source: sensemaking app, buzz.stats


longest_duration <- function(x) {


   names(x)[3] <- 'source_trigger'                                                           # the trigger column doesn't have a consistent name, so give it one
   x$trigger <- replace_na_runs(x$source_trigger, max_run = 6, boundary = FALSE)             # runs of <= 6 NA surrounded by TRUE become TRUE; others FALSE. Don't assume TRUE beyond data.

   x$Date_Time <- as.POSIXct(x$Date_Time)                                                    # convert time from text to time object


   m <- x$Date_Time == as.POSIXct(x$Date)                                                    # well, this is annoying: runs that end at midnight are too short, because midnight is tomorrow
   x$Date[m] <- as.character(lubridate::date(x$Date_Time[m] - 1))                            # subtract 1 second to treat midnight as today 🙄


   days <- unique(x$Date)                                                                    # we'll loop through days
   z <- rep(NA, length(days))                                                                # result is a vector with a value for each day
   for(i in 1:length(days)) {                                                                # for each day,
      y <- x[x$Date %in% c(days[i], days[max(i - 1, 1)]), ]
      y$today <- y$Date == days[i]
      if(!all(is.na(y$source_trigger))) {                                                    #    if we have any non-NA triggers,
         y$g <- cumsum(y$trigger & !c(FALSE, y$trigger[-length(y$trigger)])) * y$trigger     #    make grouping variable of runs of TRUEs

         for(j in length(y$g):2)                                                             #    extend each group to the next sample so we get proper periods
            if(y$g[j] == FALSE)
               y$g[j] <- y$g[j - 1]

         d <- cbind(start = aggregate(y$Date_Time, by = list(y$g), FUN = 'min'),
                    end = aggregate(y$Date_Time, by = list(y$g), FUN = 'max'))               #    deltas in sec
         d <- d[d$start.Group.1 != 0,]                                                       #    drop group 0
         d <- d[d$start.Group.1 %in% y$g[y$today], ]                                         #    and drop groups that didn't occur today
         if(dim(d)[1] > 0) {                                                                 #    if any runs,
            z[i] <- max((lubridate::as.duration(d$end.x - d$start.x)) / dhours(1))           #       max duration below threshold in fractional hours
         }
         if(is.na(z[i]))                                                                     #    if no low-DO events, return 0
            z[i] <- 0
         z[i] <- min(z[i], 24)                                                               #    max time to report is 24 hours
      }
   }
   z
}
