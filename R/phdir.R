##' @title Create a Plot History Directory
##'
##' @description
##'
##' These functions create the plot history directory and invisibly
##' return the path:
##'
##' - `phist_tmp_dir()` creates a ' temporary directory.  -
##' `phist_cache_dir()` uses the package's central ' cache directory.
##' - `phist_dir()` takes a user-defined ' directory.
##'
##' The directory creating is delegated to [tempdir()] by
##' `phist_tmp_dir()` and [dir.create()] by `phist_dir()` and
##' `phist_cache_dir()`.
##'
##' @param path `character(1)` with a single path name, passed to
##'     [dir.create()]. Only relevant in the user-defined case.
##'
##' @param ... Additional parameters passed to [dir.create()].
##'
##' @return Used for its side effect of creating a
##'     directory. Invisibly returns the path to the newly created
##'     directory.
##'
##' @export
phist_dir <- function(path, ...) {
    path <- path.expand(path)
    if (!dir.exists(path)) {
        success <- dir.create(path, ...)
        if (!success)
            stop("Couldn't create plot history directory.")
    }
    message("Plot history set to\n  ", path)
    invisible(path)
}

##' @export
##'
##' @rdname phist_dir
phist_tmp_dir <- function()
    phist_dir(tempdir())

##' @export
##'
##' @rdname phist_dir
phist_current_dir <- function()
    phist_dir(getwd())

##' @export
##'
##' @param ask `logical(1)` that defines whether to ask to create the
##'     cache directory it doesn't exist yet. Default is `TRUE`.
##'
##' @rdname phist_dir
phist_cache_dir <- function(ask = TRUE)
    phist_dir(phist_cache(ask))
