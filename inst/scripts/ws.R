library(httpgd)
library(websocket)

hgd(token = FALSE)

wskt <- paste0(
    "ws://", hgd_details()$host,
    ":", hgd_details()$port)

ws <- websocket::WebSocket$new(wskt ,
                               autoConnect = FALSE)

ws$onOpen(function(event) {
  cat("Connection opened\n")
})

ws$onMessage(function(event) {
    cat("Client got msg: ", event$data, "\n")
})

ws$onClose(function(event) {
  cat("Client disconnected with code ", event$code,
    " and reason ", event$reason, "\n", sep = "")
})

ws$onError(function(event) {
  cat("Client failed to connect: ", event$message, "\n")
})

ws$connect()
