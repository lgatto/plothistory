args <- commandArgs(trailingOnly = TRUE)

## check plothistory diretory
phdir <- args[1]

while(TRUE) {
    plothistory:::save_plot_to_file(phdir)
    Sys.sleep(1)
}
