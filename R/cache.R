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
##' @param ask `logical(1)` that defines whether to ask to create the
##'     cache directory it doesn't exist yet. Default is `TRUE`.
##' 
##' @return The path to the cache directory or `NA`, when it's not
##'     set.
##'     
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
##'
##' ## to set it in a non-interactive session
##' phist_cache(ask = FALSE)
phist_cache <- function(ask = TRUE) {
    cache <- tools::R_user_dir(package = "plothistory",
                               which = "cache")
    if (!file.exists(cache)) {
        if (!interactive()) {
            if (ask) return(NA)
            else {
                dir.create(cache, recursive = TRUE)
                return(cache)
            }
        }
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
