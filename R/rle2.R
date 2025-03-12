#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' A drop-in replacement for \code{base::rle()} that treats all NAs as identical
#'
#' @param x an atomic vector
#'
#' @return An object of class \code{rle}
#'
# From https://coolbutuseless.github.io/2020/08/26/run-length-encoding-and-the-problem-of-nas/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rle2 <- function (x)  {
   stopifnot("'x' must be a vector of an atomic type" = is.atomic(x))

   n <- length(x)
   if (n == 0L) {
      return(structure(list(
         lengths = integer(), values = x)
      ), class = 'rle')
   }

   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   # Where does next value not equal current value?
   # i.e. y will be TRUE at the last index before a change
   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   y <- (x[-1L] != x[-n])

   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   # Since NAs are never equal to anything, NAs in 'x' will lead to NAs in 'y'.
   # These current NAs in 'y' tell use nothing - Set all NAs in y to FALSE
   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   y[is.na(y)] <- FALSE

   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   # When a value in x is NA and its successor is not (or vice versa) then that
   # should also count as a value change and location in 'y' should be set to TRUE
   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   y <- y | xor(is.na(x[-1L]), is.na(x[-n]))

   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   # Any TRUE locations in 'y' are the end of a run, where the next value
   # changes to something different
   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   i <- c(which(y), n)

   structure(list(
      lengths = diff(c(0L, i)),
      values  = x[i]
   ), class = 'rle')
}
