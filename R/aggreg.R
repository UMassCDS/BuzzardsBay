#' Improved version of aggregate
#'
#' Improve on miserable `aggregate` function:
#' - ignore NAs
#' - return NA if all in group are Inf or NaN
#' - no warnings
#' - sort by grouping variable and optionally return only result column
#' - optionally drop groups with too many NAs
#'
#' @param x Vector to aggregate
#' @param by Vector(s) to group by (if only 1 grouping variable, this doesn't have to be a list)
#' @param FUN Function to summarize with
#' @param drop_by If TRUE, drop the grouping variable and just return a vector; otherwise,
#' return a data frame
#' @param nomiss If not NULL, this represents a proportion of the data in a group that must
#' be non-missing; if this threshold isn't met, the result for the group will be NA
#' @return Vector of aggregated values (if drop_by = TRUE), or data frame of groups
#' and aggregated values (if drop_by = FALSE)
#' @import stats
#' @keywords internal


'aggreg' <- function(x, by, FUN, drop_by = TRUE, nomiss = NULL) {


   if(!is.list(by))
      by <- list(by)
   z <- suppressWarnings(aggregate(x, by, FUN, na.rm = TRUE))                 # no whining on min or max on all NAs

   if(!is.null(nomiss))                                                       # if we have a non-missing threshold,
      z$x[aggreg(!is.na(x), by = by, FUN = mean) < nomiss] <- NA              #    change results in groups with too few missing values to NA

   z$x[is.infinite(z$x) | is.nan(z$x)] <- NA                                  # replace crap with NA

   if(drop_by)
      z$x[order(z$Group.1)]                                                   # sort because I don't trust this thing
   else
      z[order(z$Group.1), ]
}
