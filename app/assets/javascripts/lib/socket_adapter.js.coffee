class @SocketAdapter
  constructor: (@aggregator, @reqres, @socket_url) ->
    @websocket = new WebSocket(@socket_url)
    @websocket.onmessage = @_message_processor
    @promises = {}
    @_setupListeners()

  publish: (args...) =>
    @aggregator.trigger args...

  _message_processor: (event) =>
    message = JSON.parse(event.data)
    promise = @promises[message.id]

    if promise?
      if message.error?
        promise.reject(message)
      else
        promise.resolve(message.value)

      delete @promises[message.id]

  _sendData: (json) =>
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
        @_sendData(json).then (v)-> dfd.resolve(v)

      dfd
    else
      @_sendData(json)

  _setupRubyModulesListener: ->
    @reqres.setHandler "communicator:get:ruby:modules", (moduleName) =>
      @_buildPromise
        type: "moduleSpace"
        value: moduleName

  _setupCodeModelListener: ->
    @reqres.setHandler "communicator:get:code:model", (codeModel) =>
      @_buildPromise
        type: "codeModel"
        value: codeModel.id

    @reqres.setHandler "communicator:update:code:model", (codeModel) =>
      @_buildPromise
        type: "codeModel"
        value: codeModel.toJSON()
        requestType: "update"

  _setupReplListener: ->
    @reqres.setHandler "communicator:repl:eval", (expressionModel) =>
      @_buildPromise
        type: "replExpression"
        value: expressionModel.get('expressionContent')

  _setupListeners: ->
    @_setupRubyModulesListener()
    @_setupCodeModelListener()
    @_setupReplListener()
