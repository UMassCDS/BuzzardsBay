test_that('replacing runs of NAs with TRUE works', {

   expect_equal(replace_na_runs(c(TRUE, NA, NA, NA, TRUE), max_run = 3),
                c(TRUE, TRUE, TRUE, TRUE, TRUE))                                       # string of 3 NAs surrounded by TRUE
   expect_equal(replace_na_runs(c(FALSE, NA, NA, NA, TRUE), max_run = 3),
                c(FALSE, FALSE, FALSE, FALSE, TRUE))                                   # string of 3, but there's a FALSE
   expect_equal(replace_na_runs(c(TRUE, NA, NA, NA, NA, TRUE), max_run = 3),
                c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE))                             # string of 4 is too long
   expect_equal(replace_na_runs(c(NA, NA, NA, TRUE), max_run = 3, boundary = TRUE),
                c(TRUE, TRUE, TRUE, TRUE))                                             # assuming TRUE beyond data boundary
   expect_equal(replace_na_runs(c(NA, NA, NA, TRUE), max_run = 3, boundary = FALSE),
                c(FALSE, FALSE, FALSE, TRUE))                                          # assuming FALSE beyond data boundary

})
