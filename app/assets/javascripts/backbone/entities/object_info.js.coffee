@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  # This is the model that backs an Editor view
  class Entities.ObjectInfo extends Entities.Model
    initialize: ->
      @set id: @get('identifier') if not @get('id')

    sync: (method, model, options) ->
      if method == "read"
        App.request("communicator:get:object:info", model)
        .done (value) =>
          options.success(value)
          @
        .fail (value) =>
          options.error(value)
          @
      else
        Backbone.sync method, model, options

  # class Entities.CodeModels extends Entities.Collection
  #   model: Entities.CodeModel

  App.reqres.setHandler "object:info:entity", (identifier, type) ->
    new Entities.ObjectInfo(identifier: identifier, type: type)
