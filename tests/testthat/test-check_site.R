test_that('check_site gives proper messages', {

   # set up deployment data
   example_paths <- local_example_dir(year_filter = 2024, site_filter = 'AB2')               # set up an example directory in a temporary path
   withr::local_dir(dirname(example_paths$base))                                             # set working dir to temp dir
   site_dir <- dirname(sub(paste0(getwd(), '/*'), '', example_paths$deployment))             # site_dir is a relative path, so paths shown will match across runs


   quiet(stitch_site(site_dir))                                                              # create stitched data for this test

   expect_no_error(quiet(check_site(site_dir)))
   expect_snapshot(check_site(site_dir))                                                     # snapshot of normal run

   hash <- read.table(hf <- file.path(site_dir, '/combined/hash.txt'), sep = '\t', header = TRUE)
   hash$file[c(2, 5)] <- 'a:/nowhere/not_a_file'                                             # nuke a source and result filename
   hash$hash[c(3, 6)] <- 'not_a_hash'                                                        # and hash
   write.table(hash, hf , sep = '\t', row.names = FALSE, quote = FALSE)
   expect_snapshot(check_site(site_dir))                                                     # snapshot of damaged hash file with all 4 possible errors

   file.remove(hf)
   expect_snapshot(check_site(site_dir))                                                     # snapshot of missing hash file

})
