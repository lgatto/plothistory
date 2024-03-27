test_that("works with relative filename (issue #2)", {
    tf <- tempdir()
    setwd(tf)
    plothistory(phist_dir("figs"))
    plot(1)
    expect_true(file.exists("figs/.last.svg"))
})
