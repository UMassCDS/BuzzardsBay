#' Produce daily stats for a site
#'
#' Produces a data frame of daily stats.
#'
#' @param core Core data frame, produced by `stitch_site`
#' @return Data frame with one row for each day of deployment, and columns with a number of statistics
#' @import stats
#' @keywords internal


daily_stats <- function(core) {


   cols <- c('Date', 'Min_DO', 'Min_DO_Time', 'Prop_Under_6', 'Duration_Under_6',
             'Prop_Under_3', 'Duration_Under_3', 'Mean_DO', 'SD_DO',
             'Mean_Salinity', 'SD_Salinity', 'Range_DO', 'Range_DO_Sat',
             'Min_Temp', 'Max_Temp')


   z <- aggreg(core$DO, core$Date, min, drop_by = FALSE)
   names(z) <- c('Date', 'Min_DO')                                               # Date and min DO

   x <- merge(z, core, by = 'Date')[, c('Date', 'Date_Time', 'DO', 'Min_DO')]    # time and date of minimum DO
   x <- x[(!is.na(x$DO)) & x$DO == x$Min_DO, ]
   x <- aggreg(x$Date_Time, x$Date, min, drop_by = FALSE)
   x <- merge(z, x, by.x = 'Date', by.y = 'Group.1', all = TRUE)
   x$x <- substring(x$x, regexpr('\\d{2}:\\d{2}:\\d{2}$', x$x))                  # we'll report this as time, not date and time
   z$Min_DO_Time <- x$x

   core$DO6 <- core$DO < 6                                                       # proportion with DO < 6 mg/L
   z$Prop_Under_6 <- aggreg(core$DO6, core$Date, sum) /
      aggreg(!is.na(core$DO), core$Date, sum)
   z$Prop_Under_6[is.nan(z$Prop_Under_6)] <- NA

   z$Duration_Under_6 <- longest_duration(core[, c('Date', 'Date_Time', 'DO6')]) # duration of longest run under 6 mg/L

   core$DO3 <- core$DO < 3                                                       # proportion with DO < 3 mg/L
   z$Prop_Under_3 <- aggreg(core$DO6, core$Date, sum) /
      aggreg(!is.na(core$DO), core$Date, sum)
   z$Prop_Under_3[is.nan(z$Prop_Under_3)] <- NA

   z$Duration_Under_3 <- longest_duration(core[, c('Date', 'Date_Time', 'DO3')]) # duration of longest run under 3 mg/L

   z$Mean_DO <- aggreg(core$DO, core$Date, mean)                                 # mean DO
   z$SD_DO <- aggreg(core$DO, core$Date, sd)                                     # sd DO
   z$Mean_Salinity <- aggreg(core$Salinity, core$Date, mean)                     # mean salinity
   z$SD_Salinity <- aggreg(core$Salinity, core$Date, sd)                         # sd salinity
   z$Range_DO <- aggreg(core$DO, core$Date, max) - z$Min_DO                      # range of DO
   z$Range_DO_Sat <- aggreg(core$DO_Pct_Sat, core$Date, max) -
      aggreg(core$DO_Pct_Sat, core$Date, min)                                    # range of DO % saturation
   z$Min_Temp <- aggreg(core$Temp_CondLog, core$Date, min)                       # minimum temperature
   z$Max_Temp <- aggreg(core$Temp_CondLog, core$Date, max)                       # maximum temperature


   z <- z[, cols]                                                                # Just return the good stuff, in canonical order


   r <- read.csv(system.file('extdata/rounding.csv', package = 'BuzzardsBay',
                             mustWork = TRUE))                                   # Now do rounding - read rounding file
   r <- r[r$table == 'daily', ]                                                  # just for daily stats
   r$digits <- as.numeric(r$digits)
   for(i in 1:dim(r)[1])                                                         # for each row in rounding file,
      if(r$column[i] %in% cols)                                                   #    if it's one of our columns,
         z[, r$column[i]] <- round(z[, r$column[i]], r$digits[i])                  #       round it

   z
}
