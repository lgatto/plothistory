##' @title Record Your Plot History
##'
##' @param phdir `character(1)` defining the plothistory
##'     directory. Default is to [phist_tmp_dir()].
##'
##' @param sleep `numeric(1)` > 0 indicating the clock cycle in
##'     seconds. at which `phdir` should be updated. Default is 1
##'     second. Passed to [Sys.sleep()].
##'
##' @param port `numeric(1)` defining the server port, passed to
##'     [httpgd::hgd()]. If this is set to ‘0’, an open port will be
##'     assigned. Default is 5900.
##'
##' @param token Optional security token, passed to
##'     [httpgd::hgd()]. Default is `FALSE` to deactivate the token.
##'
##' @export
##'
##' @importFrom httpgd hgd
##'
##' @return The value of the error code (0 for success) of the
##'     background script. See [system2()] for details.
plothistory <- function(phdir = phist_tmp_dir(),
                        sleep = 1,
                        port = 5900,
                        token = FALSE,
                        ...) {
    force(phdir)
    hgd(port = port, token = token, ...)
    plot(1, type = "n", axes = FALSE, xlab = NA, ylab = NA)
    script <- system.file("scripts",
                          package = "plothistory",
                          pattern = "plothistory.R")
    args <- c(script, phdir, sleep)
    system2("Rscript", args = args, wait = FALSE)
}

## called in script/plothistory.R
run_plothistory <- function(phdir, sleep) {
    on.exit(httpgd::hgd_close())
    while(TRUE) {
        save_plot_to_file(get_plot(), phdir)
        Sys.sleep(sleep)
    }
}
