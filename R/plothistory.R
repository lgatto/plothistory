##' @title Record Your Plot History
##'
##' @description The `plothistory()` function initiates saving all
##'     plots generated during the session in `phdir`. It works as
##'     follows:
##'
##' - It first starts a web server graphics device [httpgd::hgd()].
##'
##' - Next it creates and runs a websocket connected to the graphics
##'   device.
##'
##' - Every time the user creates a plot, the web socket receives an
##'   event that triggers the saving of the plot into the user defined
##'   directory `phdir`.
##'
##' @param phdir `character(1)` defining the plothistory
##'     directory. Default is to [phist_tmp_dir()].
##'
##' @param ... additional parameters passed to [httpgd::hgd()].
##'
##' @export
##'
##' @importFrom httpgd hgd hgd_details
##' @importFrom unigd ugd_save
##' @importFrom websocket WebSocket
##' @importFrom jsonlite parse_json
##'
##' @return The value of the error code (0 for success) of the
##'     background script.
plothistory <- function(phdir = phist_tmp_dir(), ...) {
    force(phdir)
    phdir <- path.expand(phdir)
    stopifnot(dir.exists(phdir))
    n <- 0 ## plot counter

    httpgd::hgd(token = FALSE, ...)
    wskt <- paste0(
        "ws://", hgd_details()$host,":",
        hgd_details()$port)
    ws <- WebSocket$new(wskt, autoConnect = FALSE)
    ws$onMessage(function(event) {
        n <- get("n")
        hs <- parse_json(event$data)$hsize
        if (hs > n)
            save_plot_to_file(phdir)
        n <<- hs
    })
    ws$connect()
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
    ugd_save(file = fl)
    on.exit(unlink(fl))
    md5 <- tools::md5sum(fl)
    newf <- file.path(dir, paste0(md5[[1]], ".svg"))
    file.rename(from = fl, to = newf)
    unlink(lnsym)
    file.symlink(newf, lnsym)
    invisible(newf)
}
