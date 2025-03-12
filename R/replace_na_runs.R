   #' Replace short runs of NA in logical vector
   #'
   #' Any runs of NA not longer than `max_run` that are surrounded by TRUE are
   #' replaced with TRUE. All other NAs are replaced with FALSE.
   #'
   #' Use `boundary` to specify behavior at data boundaries. For instance, if bounadary = TRUE,
   #' then c(NA, TRUE) would result in c(TRUE, TRUE); otherwise the result would be c(FALSE, TRUE).
   #'
   #' @param x A logical vector that may have NAs
   #' @param max_run The maximum run length to replace
   #' @param boundary How to treat values beyond the edge of the data
   #' @return A vector corresponding to `x` where qualifying runs have been replaced with TRUE
   #' @keywords internal


replace_na_runs <- function(x, max_run = 6, boundary = FALSE) {


   y <- rle2(x)                                                # get lengths and values of runs (including runs of NA, thus rle2 and not base::rle)

   istrue <- !is.na(y$values) & y$values                       # TRUE for TRUE, FALSE for FALSE or NA

   isna <- is.na(y$values)                                     # runs that are NA
   isshort = y$lengths <= max_run                              # runs that are no longer than max_run
   truebefore = c(istrue[-1], boundary)                        # runs preceded by TRUE
   trueafter = c(boundary, istrue[-length(istrue)])            # runs followed by TRUE

   y$values[isna & isshort & truebefore & trueafter] <- TRUE   # put it all together - these are our qualifying runs
   y$values[is.na(y$values)] <- FALSE                          # non-qualifying NAs become FALSE
   inverse.rle(y)                                              # pull it back into the form of the original vector
}
