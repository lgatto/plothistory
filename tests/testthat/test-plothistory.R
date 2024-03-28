## test_that("works with absolute and relative filenames", {
##     td <- tempdir(check = TRUE)
##     setwd(td)
##     f <- file.path(td, "figs")
##     ans <- file.path(td, "figs/.last.svg")
##     plothistory(phist_dir(f))
##     expect_true(file.exists(ans))
##     httpgd::hgd_close()
## })


## test_that("works with relative filename (issue #2)", {
##     td <- tempdir(check = TRUE)
##     setwd(td)
##     f <- "figs"
##     ans <- file.path(td, "figs/.last.svg")
##     plothistory(phist_dir(f))
##     expect_true(file.exists(ans))
##     httpgd::hgd_close()
## })
