#' cut items off the end of a path
#'
#' @param x A path
#' @param ncut The number of items to cut
#'
#' @return A shortened path
#' @examples
#' \dontrun{
#'   deployment_dir <- "C:/temp/bb_demo//BB_Data/2023/RB1/2023-06-09"
#'   base_dir <- cut_path_items(deployment_dir, 3)
#' }
cut_path_items <- function(x, ncut) {
  re <- paste0("(^.*)",
               paste(rep("[/\\\\]+[^/\\\\]+", ncut), collapse = ""),
               "[/\\\\]*$")
  return(gsub(re, "\\1", x, perl = TRUE))
}
