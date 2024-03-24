##' @title plothistory Package Cache
##'
##' @description
##'
##' Function to access (and manage) the plothistory package
##' cache. `phist_chache()` returns the central `plothistory` cache
##' directory.
##'
##' When plots are cached, they are named after their md5sum.
##'
##' @return The `phist_cache()` function returns an instance of class
##'     `BiocFileCache`.
##'
##' @author Laurent Gatto
##'
##' @export
##'
##' @importFrom tools R_user_dir
##'
##' @examples
##'
##' phist_cache()
phist_cache <- function() {
    cache <- tools::R_user_dir(package = "plothistory",
                               which = "cache")
    if (!file.exists(cache)) {
        if (!interactive()) return(FALSE)
        txt <- paste0(cache,
                   "\n does not exist, create directory? (yes/no): ")
        doit <- NA
        while (is.na(doit)) {
            response <- substr(tolower(readline(txt)), 1, 1)
            doit <- switch(response, y = TRUE, n = FALSE, NA)
        }
        if (doit)
            dir.create(cache, recursive = TRUE)
    }
    return(cache)
}
