class @SocketAdapter
  constructor: (@aggregator, @socket_url) ->
    @websocket = new WebSocket(@socket_url)
    @websocket.onmessage = @_message_processor

  publish: (args...) =>
    @aggregator.trigger args...

  _message_processor: (event) =>
    message = JSON.parse(event.data)

    switch message.type
      when "result"
        console.log "trying to publish"
        console.log message
        @publish("socket:value", message.value)
