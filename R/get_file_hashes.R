#' Get md5 hashes for a vector of files
#'
#' Given one or more file paths and names, return md5 hashes for each. Returns
#' NA for files that don't exist.
#'
#' @param files A list of full file specifications
#' @return A matching vector of md5 hashes
#' @keywords internal


get_file_hashes <- function(files) {


   z <- rep(NA, length(files))
   for(i in 1:length(files)) {
      if(file.exists(files[i])) {
         x <- readr::read_file(files[i])
         z[i] <- digest::digest(x, algo = 'md5')
      }
      else
         z[i] <- NA
   }

   z
}
