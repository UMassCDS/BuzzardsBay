'longest_duration' <- function(x) {

   #' Give the longest run of TRUEs
   #'
   #' Used to find the longest run of DO below a threshold.
   #
   #' @param x Data frame with columns `Date_Time` and `trigger` (TRUE when the trigger condition is met)
   #' @return Length of the longest run of TRUEs in hh:mm
   # Source: sensemaking app, buzz.stats



   'fmt.hm' <- function(x) {                                                              # format minutes as h:mm
      x <- round(x, 0)
      paste(floor(x / 60), sprintf('%02d', x - floor(x / 60) * 60), sep = ':')
   }


   x$Date_Time <- as.POSIXct(x$Date_Time)

   se <- x$trigger
   #  se[is.na(se)] <- FALSE                                                                                      # treat missing values as NOT below CT
   #  *** need to treat runs of NA surrounded by TRUE as TRUE

   g <- cumsum(se & !c(FALSE, se[-length(se)])) * se                                                           # make grouping variable of runs of TRUEs
   for(i in length(g):2)                                                                                       # extend each group to the next sample so we get proper periods
      if(g[i] == FALSE)
         g[i] <- g[i - 1]
   d <- cbind(aggregate(x$Date_Time, by = list(g), FUN = 'max'),
              aggregate(x$Date_Time, by = list(g), FUN = 'min'))                                               # deltas in sec
   d <- d[d$Group.1 != 0,]                                                                                     # drop group 0
   z <- as.numeric(lubridate::as.duration(d[, 2] - d[, 4])) / 60                                               # duration below threshold in minutes
   z <- z[z != 0]                                                                                              # this can happen if the last point is below the threshold

   if(length(z) > 0) {
      z <- fmt.hm(max(z))                                                                            # max minutes below CT threshold
   }
   z
}
