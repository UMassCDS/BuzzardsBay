#' Produce seasonal stats for a site
#'
#' Produces a data frame of seasonal stats.
#'
#' @param core Core data frame, produced by `stitch_site`
#' @return Data frame with a column of the statistic name and a column with the statistic
#' @keywords internal


seasonal_stats <- function(core) {

   core<<-core

   stats <- c('Day', 'n(Salinity)', 'n(DO)', 'n(Temperature)', 'Percent of data missing', 'Min DO (mg/L)',
              'Q1 DO (mg/L)', 'Median DO (mg/L)', 'Mean DO (mg/L)', 'Q3 DO (mg/L)', 'Max DO (mg/L)',
              'Min Temp (C)', 'Q1 Temp (C)', 'Median Temp (C)', 'Mean Temp (C)', 'Q3 Temp (C)',
              'Max Temp (C)', 'Standard deviation of temperature (C)',
              'First date with DO < 6 mg/L', 'First date with DO < 3 mg/L',
              'Days with DO < 6 mg/L', 'Days with DO < 3 mg/L', 'P(DO < 6 mg/L)', 'P(DO < 3 mg/L)',
              'Mean duration of DO < 6 mg/L (hours)*', 'Mean duration of DO < 3 mg/L (hours)* ',

              'First day warmer than 20 C', 'Last day warmer than 20 C')

   stat_abbrev <- c('day', 'n_sal', 'n_do', 'n_temp', 'pct_na', 'min_do',
                    'q1_do', 'median_do', 'mean_do', 'q3_do', 'max_do',
                    'min_temp', 'q1_temp', 'median_temp', 'mean_temp', 'q3_temp',
                    'max_temp', 'std_temp',
                    'first_do_6', 'first_do_3',
                    'days_do_6', 'days_do_3', 'p_do_6', 'p_do_3',
                    'mean_do_6', 'mean_do_3',
                    'first_warm', 'last_warm')

   z <- data.frame(Statistic = stats, Value = NA)
   row.names(z) <- stat_abbrev


   z['day', 'Value'] <- length(unique(core$Date))

   z['n_sal', 'Value'] <- sum(!is.na(core$Salinity))
   z['n_do', 'Value'] <- sum(!is.na(core$DO))
   z['n_temp', 'Value'] <- sum(!is.na(core$Temp_CondLog))

   z['pct_na', 'Value'] <- sum(apply(is.na(core[, c('Temp_CondLog', 'DO', 'Salinity')]), 1, FUN = any)) / dim(core)[1] * 100   # *** provisionally, % of rows with any missing in temp, DO, or salinity

   s <- summary(core$DO)
   z['min_do', 'Value'] <- s[1]
   z['q1_do', 'Value'] <- s[2]
   z['median_do', 'Value'] <- s[3]
   z['mean_do', 'Value'] <- s[4]
   z['q3_do', 'Value'] <- s[5]
   z['max_do', 'Value'] <- s[6]

   s <- summary(core$Temp_CondLog)
   z['min_temp', 'Value'] <- s[1]
   z['q1_temp', 'Value'] <- s[2]
   z['median_temp', 'Value'] <- s[3]
   z['mean_temp', 'Value'] <- s[4]
   z['q3_temp', 'Value'] <- s[5]
   z['max_temp', 'Value'] <- s[6]

   z['std_temp', 'Value'] <- sd(core$Temp_CondLog, na.rm = TRUE)

   z['first_do_6', 'Value'] <- core$Date[core$DO < 6][1]                         # we'll get NA if DO never falls below threshold
   z['first_do_3', 'Value'] <- core$Date[core$DO < 3][1]

   z['days_do_6', 'Value'] <- length(unique(core$Date[core$DO < 6 & !is.na(core$DO)]))
   z['days_do_3', 'Value'] <- length(unique(core$Date[core$DO < 3 & !is.na(core$DO)]))

   z['p_do_6', 'Value'] <- sum(core$DO < 6, na.rm = TRUE) / sum(!is.na(core$DO))
   z['p_do_3', 'Value'] <- sum(core$DO < 3, na.rm = TRUE) / sum(!is.na(core$DO))

   z['mean_do_6', 'Value'] <- mean_daily_durations(core, 6)                # *** provisionally, mean duration <6 mg/L; noon-noon days entirely above threshold omitted
   z['mean_do_3', 'Value'] <- mean_daily_durations(core, 3)

   z['first_warm', 'Value'] <- (w <- core$Date[core$Temp_CondLog > 20 & !is.na(core$Temp_CondLog)])[1]
   z['last_warm', 'Value'] <- w[length(w)]

   z
   # going to have to make Value a string column so I can do rounding. Gonna be annoying. Will have to right justify. Maybe insert units there instead of in Statistic.
   # hmm. and date forces is to string, so we'll have to do rounding as we go or in a batch before adding any dates.
}
