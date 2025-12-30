test_that('we get proper file hashes', {

  test_dir <- withr::local_tempdir("hashtest")

   # Write files in a cross platform
   x <- file.path(test_dir, c('one.txt', 'two.txt', 'three.txt'))
   con1 <- file(x[1], "w", encoding = "UTF-8")
   con2 <- file(x[2], "w", encoding = "UTF-8")
   writeLines('This is some text', con1, sep = "\n")
   writeLines('This is some different text', con2, sep = "\n")
   close.connection(con1)
   close.connection(con2)

   expect_snapshot(get_file_hashes(x))
})
