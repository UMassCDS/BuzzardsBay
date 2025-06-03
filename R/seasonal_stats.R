#' Produce seasonal stats for a site
#'
#' Produces a data frame of seasonal stats.
#'
#' @param core Core data frame, produced by `stitch_site`
#' @return List of:
#' \item{`table`}{Data frame with a column of the statistic name and a column with the numeric statistics}
#' \item{`formatted`}{Data frame with a column of the statistic name and a column with the formatted statistics}
#' @import stats
#' @keywords internal


seasonal_stats <- function(core) {

   stats <- c('Days', 'n(Salinity)', 'n(DO)', 'n(Temperature)', 'Percent of rows with missing data', 'Min DO (mg/L)',
              'Q1 DO (mg/L)', 'Median DO (mg/L)', 'Mean DO (mg/L)', 'Q3 DO (mg/L)', 'Max DO (mg/L)',
              'Min Temp (C)', 'Q1 Temp (C)', 'Median Temp (C)', 'Mean Temp (C)', 'Q3 Temp (C)',
              'Max Temp (C)', 'Standard deviation of temperature (C)',
              'First date with DO < 6 mg/L', 'First date with DO < 3 mg/L',
              'Days with DO < 6 mg/L', 'Days with DO < 3 mg/L', 'P(DO < 6 mg/L)', 'P(DO < 3 mg/L)',
              'Mean duration of DO < 6 mg/L (hours)*', 'Mean duration of DO < 3 mg/L (hours)*',
              'First day warmer than 20 C', 'Last day warmer than 20 C')

   stat_abbrev <- c('days', 'n_sal', 'n_do', 'n_temp', 'pct_na', 'min_do',
                    'q1_do', 'median_do', 'mean_do', 'q3_do', 'max_do',
                    'min_temp', 'q1_temp', 'median_temp', 'mean_temp', 'q3_temp',
                    'max_temp', 'std_temp',
                    'first_do_6', 'first_do_3',
                    'days_do_6', 'days_do_3', 'p_do_6', 'p_do_3',
                    'mean_do_6', 'mean_do_3',
                    'first_warm', 'last_warm')

   z <- data.frame(stat = stats, value = NA)                                        # result data frame
   row.names(z) <- stat_abbrev
   z2 <- z

   y <- list()                                                                      # intermediate result list (as we have mixed types in result)


   y[['days']] <- length(unique(core$Date))

   y[['n_sal']] <- sum(!is.na(core$Salinity))
   y[['n_do']] <- sum(!is.na(core$DO))
   y[['n_temp']] <- sum(!is.na(core$Temp_CondLog))

   na_cols <- core[, c('Temp_CondLog', 'DO', 'Salinity')]
   y[['pct_na']] <- sum(apply(is.na(na_cols), 1, FUN = any)) / dim(core)[1] * 100   # *** provisionally, % of rows with any missing in temp, DO, or salinity

   s <- summary(core$DO)
   y[['min_do']] <- s[1]
   y[['q1_do']] <- s[2]
   y[['median_do']] <- s[3]
   y[['mean_do']] <- s[4]
   y[['q3_do']] <- s[5]
   y[['max_do']] <- s[6]

   s <- summary(core$Temp_CondLog)
   y[['min_temp']] <- s[1]
   y[['q1_temp']] <- s[2]
   y[['median_temp']] <- s[3]
   y[['mean_temp']] <- s[4]
   y[['q3_temp']] <- s[5]
   y[['max_temp']] <- s[6]

   y[['std_temp']] <- sd(core$Temp_CondLog, na.rm = TRUE)

   y[['first_do_6']] <- c(as.character(core$Date[core$DO < 6 & !is.na(core$DO)]), 'None')[1]
   y[['first_do_3']] <- c(as.character(core$Date[core$DO < 3 & !is.na(core$DO)]), 'None')[1]

   y[['days_do_6']] <- length(unique(core$Date[core$DO < 6 & !is.na(core$DO)]))
   y[['days_do_3']] <- length(unique(core$Date[core$DO < 3 & !is.na(core$DO)]))

   y[['p_do_6']] <- sum(core$DO < 6, na.rm = TRUE) / sum(!is.na(core$DO))
   y[['p_do_3']] <- sum(core$DO < 3, na.rm = TRUE) / sum(!is.na(core$DO))

   y[['mean_do_6']] <- mean_daily_durations(core, 6)                                # *** provisionally, mean duration <6 mg/L; noon-noon days entirely above threshold omitted
   y[['mean_do_3']] <- mean_daily_durations(core, 3)

   y[['first_warm']] <- (w <- core$Date[core$Temp_CondLog > 20 & !is.na(core$Temp_CondLog)])[1]
   y[['last_warm']] <- w[length(w)]


   r <- read.csv(system.file('extdata/rounding.csv', package = 'BuzzardsBay',
                             mustWork = TRUE))                                      # Now do rounding - read rounding file
   r <- r[r$table == 'seasonal', ]                                                  # just for seasonal stats
   for(i in 1:length(y)) {                                                          # for each statistic,
      f <- r$digits[r$column == names(y[i])]                                        #    format date, percent, or digits

      z2[names(y[i]), 'value'] <- switch(f,
                                         'date' = as.character(y[[i]]),
                                         'percent' = round(y[[i]], 0),
                                         round(y[[i]], as.numeric(f))
      )

      z[names(y[i]), 'value'] <- switch(f,
                                        'date' = as.character(y[[i]]),
                                        'percent' = paste0(round(y[[i]], 0), '%'),
                                        format(round(y[[i]], as.numeric(f)),
                                               nsmall = as.numeric(f), big.mark = ',')
      )
   }

   z2$stat <- sub('*', '', z2$stat, fixed = TRUE)                                   # drop asterisks from .CSV version

   list(table = z2, formatted = z)
}
