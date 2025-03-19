test_that('report is correct', {

   # set up deployment data
   example_paths <- local_example_dir(year_filter = 2024, site_filter = 'AB2',
                                      delete_old = TRUE)                                        # set up an example directory in a temporary path
   withr::local_dir(dirname(example_paths$base))                                                # set working dir to temp dir
   site_dir <- dirname(sub(paste0(getwd(), '/*'), '', example_paths$deployment))                # site_dir is a relative path, so paths shown will match across runs

   f <- file.path(site_dir, '2024-08-16/QC_AB2_2024-08-16.csv')                                 # now add lots of QC codes to the first deployment
   x <- read.csv(f)

   x$Gen_QC[c(300:550, 575:600, 800:900, 910:920)] <- 9                                         # bomb QC codes in first deployment with long strings of rejections
   x$DO[1000:1400] <- 5.5                                                                       # set DO to below 6 for 3 days or so
   write.csv(x, f)


   quiet(stitch_site(site_dir))                                                                 # stitch our modified data
   expect_no_error(quiet(report_site(site_dir, baywatchers = FALSE)))                           # want to see no errors and correct messaging
   expect_snapshot(report_site(site_dir, baywatchers = FALSE))

   f <- file.path(site_dir, 'combined/daily_stats_AB2_2024.csv')                                # check stats
   expect_snapshot(read.csv(f))

   writeLines('abcdef', file.path(site_dir, 'combined/report_hash.txt'))                        # trash the report hash
   expect_no_error(quiet(check_site(site_dir)))                                                 # this shouldn't matter

})
