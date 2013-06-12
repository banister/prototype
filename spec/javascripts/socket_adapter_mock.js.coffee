class @SocketAdapter
  constructor: (@aggregator, @reqres, @socket_url) ->
    @_setup_listeners()

  _setupRubyModulesListener: ->
    @reqres.setHandler "communicator:get:ruby:modules", (moduleName) =>

  dictionary:
    "M::A":
      code: "class A\n  def alpha\n'alpha'\nend\nend\n"
      fullName: "M::A"
      id: "M::A"
      originalSourceInfo:
        sourceLocation: ["a.rb", 1]
        lineCount: 5

    "M::C":
      code: "class C\n  def ceph\n'ceph'\nend\nend\n"
      fullName: "M::C"
      id: "M::C"
      originalSourceInfo:
        sourceLocation: ["c.rb", 1]
        lineCount: 5


  _setupCodeModelListener: ->
    @reqres.setHandler "communicator:get:code:model", (codeModel) =>
      dfd = $.Deferred()

      if @dictionary[codeModel.id]?
        dfd.resolve @dictionary[codeModel.id]
      else
        dfd.reject()

      dfd.promise()

    @reqres.setHandler "communicator:update:code:model", (codeModel) =>
      dfd = $.Deferred()
      dfd.resolve(codeModel)
      dfd.promise()

  _setup_listeners: ->
    @_setupRubyModulesListener()
    @_setupCodeModelListener()
