@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.RubyModule extends Entities.Model
    initialize: ->
      @fullName = @get('fullName')
      @set id: @fullName

      @processChildElements()

    processChildElements: ->
      if Array.isArray @get('children')
        @set children: new Entities.RubyModules(@get('children'))

    sync: (method, model, options) ->
      if method == "read"
        App.request("communicator:get:ruby_modules", model.id).then (value) =>
          options.success(value)
          @processChildElements()
          @
      else
        Backbone.sync method, model, options

    findModuleByFullName: (fullName) ->
      if @fullName == fullName
        @
      else
        @findModuleByFullNameInChildren(fullName)

    children: -> @get('children')

    fullNameAsArray: -> @_splitModuleName(@fullName)

    findModuleByFullNameInChildren: (fullName) ->
      return undefined if !@get('children')

      localSplit =  @fullNameAsArray()
      fullNameSplit = @_splitModuleName(fullName)

      if fullName == "Object" or localSplit.length < fullNameSplit.length
        newLookup = fullNameSplit[0..localSplit.length].join("::")
        @get('children').get(newLookup)?.findModuleByFullName(fullName)
      else
        console.log "error: can't locate module definition"
        return null

    _splitModuleName: (moduleName) ->
      _.str.words moduleName, "::"

  class Entities.RubyModules extends Entities.Collection
    model: Entities.RubyModule

  App.reqres.setHandler "ruby_module:entities", (moduleName) ->
    promise = $.Deferred()
    App.request("communicator:get:ruby_modules", moduleName)?.then (value) ->
      promise.resolve new Entities.RubyModule(value)

    promise.promise()
