test_that('aggreg works', {

   x <- data.frame(group = c(1, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 4, 5, NA, 5),
                   x1 = seq(1:18), x2 = seq(1:18))
   x$x2[c(3:6, 7:8, 14)] <- NA


   expect_snapshot(aggreg(x$x1, by = x$group, FUN = sum))
   expect_snapshot(aggreg(x$x1, by = x$group, FUN = sum, drop_by = FALSE))
   expect_snapshot(aggreg(x$x2, by = x$group, FUN = sum, nomiss = 0.5))
   expect_snapshot(aggreg(x$x2, by = x$group, FUN = sum, nomiss = 0.6))

})
