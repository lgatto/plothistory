phist_update <- function(phdir, sleep) {
    on.exit(httpgd::hgd_close())
    while(TRUE) {
        plothistory:::save_plot_to_file(
                          plothistory:::get_plot(),
                          phdir)
        Sys.sleep(sleep)
    }
}
