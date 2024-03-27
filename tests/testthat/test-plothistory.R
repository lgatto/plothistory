test_that("works with relative filename (issue #2)", {
    tf <- tempdir()
    setwd(tf)
    plothistory(phist_dir("figs"))
    plot(1)
    Sys.sleep(2) ## wait to make sure the file is created
    expect_true(file.exists("figs/.last.svg"))
    ## close device
    httpgd::hgd_close()
})
