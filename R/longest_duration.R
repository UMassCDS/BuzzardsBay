'longest_duration' <- function(x) {

   #' Give duration of the longest run of low DO for each day
   #'
   #' Finds the longest run of DO below a threshold for each day.
   #
   #' @param x A data frame with three columns:
   #' 1. `Date` The date, in format 2024-05-30
   #' 2. `Date_Time` The date and time, in format 2024-05-30 16:20:00
   #' 3. `trigger` TRUE when DO is below the selected threshold (the name of this column varies)
   #' @return Length of the longest run of TRUEs in fractional hours
   # Source: sensemaking app, buzz.stats



   names(x)[3] <- 'source_trigger'                                                        # the trigger column doesn't have a consistent name, so give it one
   x$trigger <- replace_na_runs(x$source_trigger, 6, TRUE)                                # runs of up to six NA surrounded by TRUE become TRUE; others FALSE

   x$Date_Time <- as.POSIXct(x$Date_Time)                                                 # convert time from text to time object

   days <- unique(x$Date)                                                                 # we'll loop through days
   z <- rep(NA, length(days))                                                             # result is a vector with a value for each day
   for(i in 1:length(days)) {                                                             # for each day,
      y <- x[x$Date == days[i], ]
      if(!all(is.na(y$source_trigger))) {                                                 #    if we have any non-NA triggers,
         g <- cumsum(y$trigger & !c(FALSE, y$trigger[-length(y$trigger)])) * y$trigger    #    make grouping variable of runs of TRUEs
         for(j in length(g):2)                                                            #    extend each group to the next sample so we get proper periods
            if(g[j] == FALSE)
               g[j] <- g[j - 1]
         d <- cbind(aggregate(y$Date_Time, by = list(g), FUN = 'max'),
                    aggregate(y$Date_Time, by = list(g), FUN = 'min'))                    #    deltas in sec
         d <- d[d$Group.1 != 0,]                                                          #    drop group 0
         if(dim(d)[1] > 0) {                                                              #       if we
            m <- as.numeric((lubridate::as.duration(d[, 2] - d[, 4]))) / 60 ^ 2           #    duration below threshold in fractional hours
            z[i] <- max(c(m, 0))                                                          #    if no runs, duration is 0
         }
      }
   }

   z
}
