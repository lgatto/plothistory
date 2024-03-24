##' @importFrom httr2 request req_perform
##' @importFrom httpgd hgd_details
get_plot <- function(host, port) {
    det <- hgd_details()        
    if (missing(host)) host <- det$host
    if (missing(port)) port <- det$port
    url <- paste0("http://", host, ":", port, "/plot")
    readLines(url, warn = FALSE)    
}

##' @param x `character()` containing the plot to be saved.
##'
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
save_plot_to_file <- function(x, dir, lnsym = ".last.svg") {
    dir <- path.expand(dir)
    lnsym <- file.path(dir, lnsym)
    stopifnot(dir.exists(dir))
    fl <- file.path(dir, "current.svg")
    on.exit(unlink(fl))
    writeLines(x, fl)
    ## we only want files
    fls <- setdiff(list.files(dir, full.names = TRUE,
                              no.. = TRUE),
                   list.dirs(dir, recursive = FALSE))
    md5 <- tools::md5sum(fls)
    newf <- file.path(dir, paste0(md5[[fl]], ".svg"))
    if (!(anyDuplicated(md5))) {
        file.rename(from = fl, to = newf)
        unlink(lnsym)
        file.symlink(newf, lnsym)
    }
    invisible(newf)
}
