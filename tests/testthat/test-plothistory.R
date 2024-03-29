## test_that("works with absolute filenames", {
##     withr::with_dir(tempdir(),  {
##         ## working in temp directory
##         wd <- getwd()
##         f <- file.path(wd, "figs")
##         ans <- file.path(wd, "figs/.last.svg")
##         plothistory(phist_dir(f))
##         plot(rnorm(100))
##         Sys.sleep(2)
##         print(res <- file.exists(ans))
##         expect_true(TRUE)
##         plothistory(NULL)
##     })
## })

## test_that("works with relative filenames (issue #2)", {
##     withr::with_dir(tempdir(),  {
##         ## working in temp directory
##         wd <- getwd()
##         f <- "figs"
##         ans <- file.path(wd, "figs/.last.svg")
##         plothistory(phist_dir(f))
##         plot(rnorm(100))
##         expect_true(file.exists(ans))
##         plothistory(NULL)
##     })
## })
