# shared helper functions


msg <- function(...)
   cat(paste0(...), '\n', sep = '')



quiet <- function(x) {
   sink(tempfile())
   on.exit(sink())
   invisible(force(x))
}
