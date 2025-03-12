# Run unit tests for analysis module



test <- function(fn) {
   testthat::test_file(paste0('tests/testthat/test-', fn, '.R'), package = 'BuzzardsBay')
   cat('\n')
}


test('stitch_site')
test('check_site')
test('report_site')
test('replace_na_runs')
test('lookup_site_paths')
test('get_file_hashes')
