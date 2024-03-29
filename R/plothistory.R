## Package environment contains:
##
## - phdir: current plothistory directory
## - WebSocket object
##
## Both assigned in plothistory().
.phist_env <- new.env(parent = emptyenv(), hash = TRUE)

wsocket <- function()
    paste0("ws://", hgd_details()$host,":",
           hgd_details()$port)

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
##'     directory. Default is to [phist_tmp_dir()]. If set to `NULL`,
##'     plot recording is stopped.
##'
##' @param hgd `logical(1)` that defines if a web server graphics
##'     device should be initialised with [httpgd::hgd()]. Default is
##'     `TRUE`. Set to `FALSE` to simply change `phdir` and keep using
##'     the same graphics device and websocket.
##'
##' @param ext `character(1)` defining the file extension/type to save
##'     the plots to, such as "pdf", "svg", "png", "tiff", ... Default
##'     is `"svg"`. See `unigd::ugd_renderers()` to get a
##'     list of supported extensions.
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
##' @return Invisibly returns `phdir`.
##'
##' @examples
##'
##' #################################################
##' ## Start recording pdf plots in a temp directory.
##'
##' phdir <- plothistory(ext = "pdf")
##' plot(rnorm(10000))
##' plot(1:10, col = "red")
##' dir(phdir, full.names = TRUE)
##'
##' #########################################################
##' ## Recording svg plots in central cache, using same http
##' ## graphics device (with hgd = FALSE).
##'
##' phdir <- plothistory(phist_cache_dir(ask = FALSE), hgd = FALSE)
##' dir(phdir)
##' plot(rnorm(100), col = "blue")
##' plot(rnorm(100), col = "green", main = "plot")
##' dir(phdir)
##'
##' ########################
##' ## Stop recording plots.
##' length(dir(phdir))
##' plothistory(NULL)
##'
##' plot(rnorm(100))
##' plot(rnorm(100))
##'
##' ## None added
##' length(dir(phdir))
plothistory <- function(phdir = phist_tmp_dir(),
                        hgd = TRUE,
                        ext = "svg",
                        ...) {
    if (is.null(phdir)) {
        ws <- get("ws", envir = .phist_env)
        ws$close()
        return(invisible(NULL))
    }
    phdir <- path.expand(phdir)
    stopifnot(dir.exists(phdir))
    assign("phdir", phdir, envir = .phist_env)
    if (hgd) {
        n <- 0 ## plot counter
        httpgd::hgd(...)
        ws <- WebSocket$new(wsocket(), autoConnect = FALSE)
        ws$onMessage(function(event) {
            n <- get("n")
            hs <- parse_json(event$data)$hsize
            if (hs > n) {
                phdir <- get("phdir", envir = .phist_env)
                serialise(phdir, ext)
            }
            n <<- hs
        })
        ws$onClose(function(event) {
            message("Stopping plot history.")
        })
        assign("ws", ws, envir = .phist_env)
        ws$connect()
    }
    invisible(phdir)
}


##' @param dir `character(1)` with the path to the plothistory
##'     directory. See [phist_dir()] for details.
##'
##' @param ext `character(1)` defining the file extension/type to save
##'     the plots to. Default is `"svg"`.
##'
##' @return `character(1)` containing the newly created filename.
##'
##' @noRd
##'
##' @importFrom tools md5sum
serialise <- function(dir, ext = "svg") {
    dir <- path.expand(dir)
    stopifnot(dir.exists(dir))
    lnsym <- file.path(dir, paste0(".last.", ext))
    fl <- file.path(dir, paste0("current.", ext))
    ugd_save(file = fl)
    on.exit(unlink(fl))
    md5 <- tools::md5sum(fl)
    newf <- file.path(dir, paste0(md5[[1]], ".", ext))
    file.rename(from = fl, to = newf)
    unlink(lnsym)
    file.symlink(newf, lnsym)
    invisible(newf)
}
