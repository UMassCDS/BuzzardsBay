test_that('we get proper file hashes', {

   test_dir <- file.path(tempdir(), 'hashtest')                    # create a temporary directory
   if (file.exists(test_dir))
      unlink(test_dir, recursive = TRUE)
   dir.create(test_dir)

   x <- file.path(test_dir, c('one.txt', 'two.txt', 'three.txt'))
   writeLines('This is some text', x[1])
   writeLines('This is some different text', x[2])

   expect_snapshot(get_file_hashes(x))
})
