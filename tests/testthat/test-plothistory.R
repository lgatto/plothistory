## test_that("works with absolute filenames", {
##     wd <- getwd()
##     (f <- file.path(wd, "figs"))
##     (ans <- file.path(wd, "figs/.last.svg"))
##     plothistory(phist_dir(f))
##     plot(1)
##     expect_true(file.exists(ans))
##     plothistory(NULL)
##     unlink("figs", recursive = TRUE, force = TRUE)
## })

## test_that("works with relative filenames", {
##     wd <- getwd()
##     f <- "figs"
##     (ans <- file.path(wd, "figs/.last.svg"))
##     plothistory(phist_dir(f))
##     plot(1)
##     expect_true(file.exists(ans))
##     plothistory(NULL)
##     unlink("figs", recursive = TRUE, force = TRUE)
## })


## test_that("works with absolute relative filenames", {
##     td <- tempdir(check = TRUE)
##     setwd(td)
##     f <- file.path(td, "figs")
##     ans <- file.path(td, "figs/.last.svg")
##     plothistory(phist_dir(f))
##     plot(1)
##     expect_true(file.exists(ans))
##     plothistory(NULL)
##     unlink(td, recursive = TRUE, force = TRUE)
##     httpgd::hgd_close()
## })


## test_that("works with relative filename (issue #2)", {
##     td <- tempdir(check = TRUE)
##     setwd(td)
##     f <- "figs"
##     ans <- file.path(td, "figs/.last.svg")
##     plothistory(phist_dir(f))
##     plot(1)
##     expect_true(file.exists(ans))
##     plothistory(NULL)
##     httpgd::hgd_close()
## })
