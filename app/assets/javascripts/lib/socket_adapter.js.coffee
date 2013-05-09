class @SocketAdapter
  constructor: (@aggregator, @reqres, @socket_url) ->
    console.log "outputting socket url"
    console.log @socket_url
    @websocket = new WebSocket(@socket_url)
    @websocket.onmessage = @_message_processor
    @_setup_listeners()

  publish: (args...) =>
    @aggregator.trigger args...

  _message_processor: (event) =>
    console.log "got a stupid websocket message"
    message = JSON.parse(event.data)
    console.log message

    switch message.type
      when "result"
        console.log "trying to publish"
        console.log message
        @publish("socket:value", message.value)

  _setup_listeners: ->
    @reqres.setHandler "socket:get:ruby_modules", =>
      json = JSON.stringify
        type: "module_space"

      @websocket.send json
