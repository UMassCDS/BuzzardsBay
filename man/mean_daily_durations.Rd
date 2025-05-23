% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mean_daily_durations.R
\name{mean_daily_durations}
\alias{mean_daily_durations}
\title{Give mean duration of low-DO runs in hours}
\usage{
mean_daily_durations(x, threshold)
}
\arguments{
\item{x}{A data frame with three columns:
\enumerate{
\item \code{x} Data frame with Date, Date_Time, and DO
\item \code{threshold} Low-DO threshold
}}
}
\value{
Mean length of low-DO runs for days with low DO, in hours
}
\description{
Returns means of runs of DO below the specified threshold in hours. Days (noon-noon) with DO
above the threshold are excluded. We use noon to noon as most low-DO runs typically start
in the evening. Multiple day-runs are included in the means. Runs of 6 or fewer NAs surrounded
by DO below the threshold are treated as below the threshold.
}
\keyword{internal}
