##' @title Record Your Plot History
##'
##' @param phdir `character(1)` defining the plothistory
##'     directory. Default is to [phist_tmp_dir()].
##'
##' @export
##'
##' @return Invisibly returns `TRUE`
plothistory <- function(phdir = force(phist_tmp_dir()),
                        sleep = 1) {
    dirgd()
    plot(1, type = "n", axes = FALSE, xlab = NA, ylab = NA)
    script <- system.file("scripts",
                          package = "plothistory",
                          pattern = "plothistory.R")
    args <- c(script, phdir, sleep)
    message("Running '", basename(script), "\n with args ",
            paste(args[-1], collapse = " "))
    system2("Rscript", args = args, wait = FALSE)
}
