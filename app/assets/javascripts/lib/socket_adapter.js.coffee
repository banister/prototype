class @SocketAdapter
  constructor: (@aggregator, @reqres, @socket_url) ->
    console.log "outputting socket url"
    console.log @socket_url
    @websocket = new WebSocket(@socket_url)
    @websocket.onmessage = @_message_processor
    @promises = {}
    @_setup_listeners()

  publish: (args...) =>
    @aggregator.trigger args...

  _message_processor: (event) =>
    console.log "got a stupid websocket message"
    console.log event
    message = JSON.parse(event.data)
    console.log message
    # window.msg = message

    promise = @promises[message.id]
    if promise?
      promise.resolve(message.value)
      delete @promises[message.id]

    switch message.type
      when "result"
        @promises[message.id]?.resolve(message.value)
        # @publish("socket:value", message.value)
      when "module_space"
        @promises[message.id]?.resolve(message.value)

  _setup_listeners: ->
    @reqres.setHandler "socket:get:ruby_modules", =>
      id = Date.now()
      json = JSON.stringify
        type: "module_space"
        id: id

      if @websocket.readyState == 1
        @websocket.send json
        promise = $.Deferred()
        @promises[id] = promise
        promise.promise()
