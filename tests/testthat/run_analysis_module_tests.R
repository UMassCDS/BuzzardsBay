# Run unit tests for analysis module



test <- function(fn) {
   testthat::test_file(paste0('tests/testthat/test-', fn, '.R'), package = 'BuzzardsBay')
   cat('\n')
}


test('replace_na_runs')
test('lookup_site_paths')
test('get_file_hashes')
test('stitch_site')
test('check_site')
test('daily_stats')
test('seasonal_stats')
test('get_site_name')
test('report_site')

