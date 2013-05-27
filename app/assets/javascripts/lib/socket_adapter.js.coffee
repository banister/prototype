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

  _send_data: (json) =>
    @websocket.send JSON.stringify(json)
    promise = $.Deferred()
    @promises[json.id] = promise
    promise.promise()

  _generateId: ->
    Date.now()

  _buildJson: (info) ->
    id = @_generateId()
    json =
      type: info.type
      value: info.value
      id: id

  _buildPromise: (json) ->
    if @websocket.readyState == 0
      dfd = $.Deferred()
      @websocket.onopen = =>
        @_send_data(json).then (v)-> dfd.resolve(v)

      dfd
    else
      @_send_data(json)

  _setupRubyModulesListener: ->
    @reqres.setHandler "communicator:get:ruby_modules", (moduleName) =>
      json = @_buildJson type: "moduleSpace", value: moduleName
      @_buildPromise(json)

  _setupCodeModelListener: ->
    @reqres.setHandler "communicator:get:code_model", (codeObjectName) =>
      json = @_buildJson type: "codeModel", value: codeObjectName
      @_buildPromise(json)

  _setup_listeners: ->
    @_setupRubyModulesListener()
    @_setupCodeModelListener()
