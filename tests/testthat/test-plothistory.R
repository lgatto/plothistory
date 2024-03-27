test_that("works with relative filename (issue #2)", {
    ## this fails on GHA, not sure why
    tf <- tempdir()
    setwd(tf)
    message(tf)
    plothistory(phist_dir("figs"))
    plot(1)
    expect_true(file.exists("figs/.last.svg"))
    ## close device
    httpgd::hgd_close()
})
