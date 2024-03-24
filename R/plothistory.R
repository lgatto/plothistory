##' @title Record Your Plot History
##'
##' @description The `plothistory()` function initiates saving all
##'     plots generated during the session in `phdir`. It works as
##'     follows:
##'
##' - It starts a http graphics device using [httpgd::hgd()]. By
##'   default, the localhost port is set to 5900 and no token is
##'   set. A first empty plot is created by default.
##'
##' - It then start an R script in the background that will fetch the
##'   latest plot from the [httpgd::hgd()] device, rename it using its
##'   md5sum (so as to avoid duplicating plots), and created a
##'   symbolic link ".last.svg" pointing to the latest figure.
##'
##' The background R script is automatically terminated when closing
##' the R session.
##'
##' @param phdir `character(1)` defining the plothistory
##'     directory. Default is to [phist_tmp_dir()].
##'
##' @export
##'
##' @importFrom httpgd hgd
##'
##' @return The value of the error code (0 for success) of the
##'     background script.
plothistory <- function(phdir = phist_tmp_dir()) {
    force(phdir)
    phdir <- path.expand(phdir)
    stopifnot(dir.exists(phdir))

    httpgd::hgd(port = 5900, token = FALSE)
    plot(1, type = "n", axes = FALSE, xlab = NA, ylab = NA)    
    script <- system.file("scripts",
                          package = "plothistory",
                          pattern = "plothistory.R")    
    cmd <- paste("Rscript", script, phdir)
    ## message(cmd)
    system(cmd, wait = FALSE)
}


##' @param dir `character(1)` with the path to the plothistory
##'     directory. See [phist_dir()] for details.
##'
##' @param lnsym `character(1)` with the symbolic link's name, that
##'     will point to the last plot filename.
##'
##' @return `character(1)` containing the newly created filename or
##'     `NULL`, if `x` was `length(x) == 0`.
##'
##' @noRd
##'
##' @importFrom tools md5sum
save_plot_to_file <- function(dir, lnsym = ".last.svg") {
    dir <- path.expand(dir)
    lnsym <- file.path(dir, lnsym)
    stopifnot(dir.exists(dir))
    fl <- file.path(dir, "current.svg")
    svg <- readLines("http://127.0.0.1:5900/plot", warn = FALSE)    
    writeLines(svg, fl)
    on.exit(unlink(fl))    
    md5 <- tools::md5sum(fl)    
    newf <- file.path(dir, paste0(md5[[1]], ".svg"))
    file.rename(from = fl, to = newf)
    unlink(lnsym)
    file.symlink(newf, lnsym)
    invisible(newf)
}

