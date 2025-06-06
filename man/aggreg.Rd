% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggreg.R
\name{aggreg}
\alias{aggreg}
\title{Improved version of aggregate}
\usage{
aggreg(x, by, FUN, drop_by = TRUE, nomiss = NULL)
}
\arguments{
\item{x}{Vector to aggregate}

\item{by}{Vector(s) to group by (if only 1 grouping variable, this doesn't have to be a list)}

\item{FUN}{Function to summarize with}

\item{drop_by}{If TRUE, drop the grouping variable and just return a vector; otherwise,
return a data frame}

\item{nomiss}{If not NULL, this represents a proportion of the data in a group that must
be non-missing; if this threshold isn't met, the result for the group will be NA}
}
\value{
Vector of aggregated values (if drop_by = TRUE), or data frame of groups
and aggregated values (if drop_by = FALSE)
}
\description{
Improve on miserable \code{aggregate} function:
\itemize{
\item ignore NAs
\item return NA if all in group are Inf or NaN
\item no warnings
\item sort by grouping variable and optionally return only result column
\item optionally drop groups with too many NAs
}
}
\keyword{internal}
