'get_file_hashes' <- function(files) {

   #' Get md5 hashes for a vector of files
   #'
   #' Given one or more file paths and names, return md5 hashes for each.
   #'
   #' @param files A list of full file specifications
   #' @return A matching vector of md5 hashes



   z <- rep(NA, length(files))
   for(i in 1:length(files)) {
      x <- readr::read_file(files[i])
      z[i] <- digest::digest(x, algo = 'md5')
   }

   z
}
