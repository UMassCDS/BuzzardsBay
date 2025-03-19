test_that('Seasonal stats are correct', {

   # set up deployment data
   example_paths <- local_example_dir(year_filter = 2024, site_filter = 'E33',
                                      delete_old = TRUE)                                        # set up an example directory in a temporary path
   withr::local_dir(dirname(example_paths$base))                                                # set working dir to temp dir
   site_dir <- dirname(sub(paste0(getwd(), '/*'), '', example_paths$deployment))                # site_dir is a relative path, so paths shown will match across runs


   quiet(stitch_site(site_dir))                                                                 # stitch data
   x <- read.csv(file.path(site_dir, 'combined/core_E33_2024.csv'))                             # read core file
   expect_snapshot(seasonal_stats(x))                                                           # do seasonal stats

})
