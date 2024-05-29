clean_logger_header <- function(x) {

  n <- names(x)

  n <- gsub("[#][[:digit:]]{4,}", "", n) # strip serial numbers
  n <- gsub(" ", "_", n) # space to underscore
  n <- gsub("[(]mg/L[)]_*c:.*$", "", n) # drop (mg/L)c:<stuff>
  n <- gsub("[(].*[)]", "", n) # drop parenthesis and their contents
  n <- gsub("_[Cc]onc_*$", "", n)  # Drop trailing _conc / _Conc
  n <- gsub("_ppt_*$", "", n) # Drop trailing _ppt
  n <- gsub("Percent", "Pct", n) # Abbreviate Percent
  n <- gsub("Specific", "Spec", n) # Abbreviate Specific
  n <- gsub("Conductance", "Cond", n) # Abbreviate Conductance
  n <- gsub("_*$", "", n)  # Drop trailing _
  n <- gsub("_+", "_", n) # drop duplicate _

  names(x) <- n

  return(x)
}

get_logger_sn <- function(x) {
  n <- names(x)

  # Extract and remove serial numbers from column headings
  sn_sv <- grep("[#][[:digit:]]{4,}", n)  # columns with serial numbers
  sn <- gsub("^(.*#)([[:digit:]]{4,}).*$", "\\2", n[sn_sv]) |>
    as.numeric()
  stopifnot(all(sn == sn[1]))
  sn <- sn[1]

  return(sn)
}
