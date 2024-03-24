##' @importFrom httr2 request req_perform
get_plot <- function(host = "127.0.0.1",
                     port = 5900) {
    url <- paste0("http://", host, ":",
                  port, "/plot")
    ## plot <- try(request(url) |> req_perform())
    ## if (inherits(plot, "try-error"))
    ##     return(character())
    ## else
    ##     readLines(url, warn = FALSE)
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
    ## if (!length(x)) 
    ##     return(x)
    dir <- path.expand(dir)
    lnsym <- file.path(dir, lnsym)
    stopifnot(dir.exists(dir))
    fl <- file.path(dir, "current.svg")
    on.exit(unlink(fl))
    writeLines(x, fl)
    fls <- setdiff(list.files(dir, full.names = TRUE,
                              no.. = TRUE),
                   list.dirs(dir, recursive = FALSE))
    md5 <- tools::md5sum(fls)
    newf <- file.path(dir, paste0(md5[[fl]], ".svg"))
    if (!(anyDuplicated(md5))) {
        file.rename(from = fl,
                    to = newf)
        unlink(lnsym)
        file.symlink(newf, lnsym)
    }
    invisible(newf)
}
