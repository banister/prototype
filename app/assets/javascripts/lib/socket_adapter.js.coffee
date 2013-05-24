class @SocketAdapter
  constructor: (@aggregator, @reqres, @socket_url) ->
    @websocket = new WebSocket(@socket_url)
    @websocket.onmessage = @_message_processor
    @promises = {}
    @_setup_listeners()

  publish: (args...) =>
    @aggregator.trigger args...

  _message_processor: (event) =>
    message = JSON.parse(event.data)

    promise = @promises[message.id]
    if promise?
      promise.resolve(message.value)
      delete @promises[message.id]

    switch message.type
      when "result"
        @promises[message.id]?.resolve(message.value)
      when "moduleSpace"
        @promises[message.id]?.resolve(message.value)

  _send_data: (json, id) =>
    @websocket.send json
    promise = $.Deferred()
    @promises[id] = promise
    promise.promise()

  _setup_listeners: ->
    @reqres.setHandler "communicator:get:ruby_modules", (moduleName) =>
      id = Date.now()
      json = JSON.stringify
        type: "moduleSpace"
        value: moduleName
        id: id

      if @websocket.readyState == 0
        dfd = $.Deferred()
        @websocket.onopen = =>
          @_send_data(json, id).then (v)-> dfd.resolve(v)

        dfd
      else
        @_send_data(json, id)
