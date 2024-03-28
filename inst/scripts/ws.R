library(httpgd)
library(unigd)
library(websocket)

hgd()

(wskt <- paste0(
     "ws://", hgd_details()$host,
     ":", hgd_details()$port))


ws <- websocket::WebSocket$new(wskt ,
                               autoConnect = FALSE)

ws$onOpen(function(event) {
    cat("Connection opened\n")
    cat(event$data, "\n")
})

ws$onMessage(function(event) {
    ## cat("Client got msg: ", event$data, "\n")
    hs <- jsonlite::parse_json(event$data)$hsize
    n <- get("n")
    ## message("Current is ", n, "\n")
    if (hs == (n + 1)) {
        message("New plot")
        ugd_save(file = "~/tmp/o.svg")
    }
    else if (hs == n) {
        ## Nothing
    }
    else if (hs < n) {
        message("Plot(s) deleted")
    } else
        warning("What happened?")
    n <<- hs
})

ws$onClose(function(event) {
  cat("Client disconnected with code ", event$code,
    " and reason ", event$reason, "\n", sep = "")
})

ws$onError(function(event) {
  cat("Client failed to connect: ", event$message, "\n")
})

n <- 0

ws$connect()


## Need to keep strat when hsize increases and decreases, as messages
## are returned when new plots are created (and hsize is incremented),
## when a plot is deleted (and hsize is decremented), when one zooms
## in and out, when history is hidden,


plot(1)
