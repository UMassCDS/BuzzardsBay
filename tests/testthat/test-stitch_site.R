test_that('stitching works', {

   # set up deployment data
   example_paths <- local_example_dir(year_filter = 2024, site_filter = 'AB2',
                                      delete_old = TRUE)      # set up an example directory in a temporary path

   wd <- dirname(example_paths$base)
   withr::local_dir(wd)                                          # set working dir to temp dir
   site_dir <- dirname(sub(paste0(wd, '/*'), '', example_paths$deployment))                # site_dir is a relative path, so paths shown will match across runs



   f <- file.path(site_dir, '2024-08-16/QC_AB2_2024-08-16.csv')                                 # nuke the beginning of the first deployment to save space in the package
   x <- read.csv(f)
   write.csv(x[1:1200,], f)

   unlink(file.path(site_dir, '2024-08-27'), recursive = TRUE)                                  # and drop the middle deployment to test NA generation and messages

   f <- file.path(site_dir, '2024-09-05/QC_AB2_2024-09-05.csv')                                 # and drop the end of the 3rd deployment
   x <- read.csv(f)
   write.csv(x[1:300,], f)


   f <- file.path(site_dir, '2024-08-16/QC_AB2_2024-08-16.csv')                                 # now add lots of QC codes to the first deployment
   x <- read.csv(f)

   codes <- c(1, 3, 4, 7, 9, 90, 91, 11, 12, 13, 14, NA)                                        # we'll set all of the codes for a few metrics
   sek <- function(n)
      seq(n, length.out = length(codes))
   x$Gen_QC[sek(10)] <- codes
   x$Raw_DO_QC[sek(30)] <- codes
   x$DO_QC[sek(50)] <- codes
   x$Salinity_QC[sek(70)] <- codes
   write.csv(x, f)
   expect_no_error(quiet(stitch_site(site_dir)))
   expect_snapshot(stitch_site(site_dir))
   expect_snapshot(read.csv(file.path(site_dir, 'combined', 'WPP_AB2_2024.csv'), nrows = 40))   # 1st 40 lines of WPP to meaningfully display Gen_QC and Raw_DO_QC rejections


   r <- file.path(site_dir, 'combined', list.files(file.path(site_dir, 'combined')))
   r <- r[grep('.csv$', r)]
   # expect_snapshot(get_file_hashes(r))                                                          # all 3 result files should match


   f <- file.path(site_dir, '2024-08-16/QC_AB2_2024-08-16.csv')                                 # add a deadly 9999 QC code
   x <- read.csv(f)
   x$Gen_QC[17] <- 9999
   write.csv(x, f)
   expect_error(quiet(stitch_site(site_dir)), 'QC code 9999 found in')


   x$Gen_QC[17] <- 137                                                                          # add a QC code for Gen_QC that's not in the table
   write.csv(x, f)
   expect_error(quiet(stitch_site(site_dir)), 'Invalid QC codes')

   x$Gen_QC[17] <- 0                                                                            # replace this and add bad QC codes for DO_QC
   x$DO_QC[c(18, 317)] <- 987
   expect_error(quiet(stitch_site(site_dir)), 'Invalid QC codes')

})
