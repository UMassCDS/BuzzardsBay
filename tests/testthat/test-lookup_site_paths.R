test_that('we get the right site paths', {

   # set up deployment data
   example_paths <- local_example_dir(year_filter = 2024, site_filter = 'AB2')               # set up an example directory in a temporary path
   withr::local_dir(dirname(example_paths$base))                                             # set working dir to temp dir
   site_dir <- dirname(sub(paste0(getwd(), '/*'), '', example_paths$deployment))             # site_dir is a relative path, so paths shown will match across runs

   expect_snapshot(lookup_site_paths(site_dir))
})
