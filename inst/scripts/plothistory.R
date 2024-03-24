args <- commandArgs(trailingOnly = TRUE)

## check plothistory diretory
phdir <- args[1]
phdir <- path.expand(phdir)
stopifnot(dir.exists(phdir))
    
## update every sleep seconds    
sleep <- as.numeric(args[2])
stopifnot(!is.na(sleep),
          sleep > 0)

plothistory:::run_plothistory(phdir, sleep)
