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
      if message.error?
        promise.reject(message.error)
      else
        promise.resolve(message.value)

      delete @promises[message.id]

  _send_data: (json) =>
    json.id = @_generateId()
    @websocket.send JSON.stringify(json)
    promise = $.Deferred()
    @promises[json.id] = promise
    promise.promise()

  _generateId: ->
    Date.now()

  _buildPromise: (json) ->
    if @websocket.readyState == 0
      dfd = $.Deferred()
      @websocket.onopen = =>
        @_send_data(json).then (v)-> dfd.resolve(v)

      dfd
    else
      @_send_data(json)

  _setupRubyModulesListener: ->
    @reqres.setHandler "communicator:get:ruby:modules", (moduleName) =>
      @_buildPromise
        type: "moduleSpace"
        value: moduleName

  _setupCodeModelListener: ->
    @reqres.setHandler "communicator:get:code:model", (codeObjectName) =>
      @_buildPromise
        type: "codeModel"
        value: codeObjectName

    @reqres.setHandler "communicator:update:code:model", (codeModel) =>
      @_buildPromise
        type: "codeModel"
        value: codeModel.toJSON()
        requestType: "update"

  _setup_listeners: ->
    @_setupRubyModulesListener()
    @_setupCodeModelListener()
