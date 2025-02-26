'daily_stats' <- function(site, year, core) {

  #' Produce daily stats for a site
  #'
  #' Produces a data frame of daily stats.
  #'
  #' @param site Three-letter site abbreviation
  #' @param year Year of deployment
  #' @param core Core data file, produced by `stitch_site`
  #' @return Data frame with one row for each day of depolyment, and columns with a number of statistics



  core$Date <- date(as.POSIXct(core$Date_Time))
  z <- aggregate(core$DO, list(core$Date), FUN = min, na.rm = TRUE)
  names(z) <- c('Date', 'Min_DO')

  for(i in 1:dim(z)[1]) {                                     # For each day, as several metrics must be done in a loop



  }


  # Time and date of minimum DO  Min_DO_Time  (one per day)     I think I have to loop for this
  # Daily proportion of DO (mg/L) under 6  Prop_Under_6
  # Longest daily duration of consecutive readings under 6 mg/L  Duration_Under_6
  # If no time under 6 assign 0.  If values immediately before and after NA are both under 6 we can assume the NA values are also under 6,
  # Daily proportion of DO (mg/L) under 3
  # Longest daily duration of consecutive readings under 3 mg/L  Duration_Under_3
  # Daily mean and standard deviation for DO (mg/L)  Mean_DO, SD_DO
  # Daily mean and standard deviation for salinity (ppt)  Mean_Salinity, SD_Salinity
  # Daily range of DO (max DO – min DO)  Range_DO
  # Daily range of DO Sat



}
