test_that('check_site gives proper messages', {

   # set up deployment data
   example_paths <- local_example_dir(year_filter = 2024, site_filter = 'AB2',
                                      delete_old = TRUE)                                     # set up an example directory in a temporary path
   wd <- dirname(example_paths$base)
   withr::local_dir(wd)                                                                      # set working dir to temp dir
   site_dir <- dirname(sub(paste0(wd, '/*'), '', example_paths$deployment))                  # site_dir is a relative path, so paths shown will match across runs



   quiet(stitch_site(site_dir))                                                              # create stitched data for this test

   expect_no_error(quiet(check_site(site_dir, check_baywatchers = FALSE)))
   expect_snapshot(check_site(site_dir, check_baywatchers = FALSE))                                                     # snapshot of normal run

   hash <- read.table(hf <- file.path(site_dir, '/combined/hash.txt'), sep = '\t', header = TRUE)
   hash$file[c(2, 5)] <- 'a:/nowhere/not_a_file'                                             # nuke a source and result filename
   hash$hash[c(3, 6)] <- 'not_a_hash'                                                        # and hash
   write.table(hash, hf , sep = '\t', row.names = FALSE, quote = FALSE)
   expect_snapshot(check_site(site_dir, check_baywatchers = FALSE))                          # snapshot of damaged hash file with all 4 possible errors

   file.remove(hf)
   expect_snapshot(check_site(site_dir, check_baywatchers = FALSE))                          # snapshot of missing hash file


   quiet(stitch_site(site_dir))                                                              # start over to make sure we're good on report hash
   quiet(report_site(site_dir, check = FALSE, baywatchers = FALSE))
   expect_snapshot(check_site(site_dir, check_baywatchers = FALSE))                          # snapshot when report hash is good
   writeLines('abcdef', file.path(site_dir, 'combined/report_hash.txt'))                     # trash the report hash
   expect_snapshot(check_site(site_dir, check_baywatchers = FALSE))                          # and when it's bad
})
