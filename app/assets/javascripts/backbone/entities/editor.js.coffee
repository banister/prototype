@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  # This is the model that backs an Editor view
  class Entities.CodeModel extends Entities.Model
    initialize: ->
      @set id: @get('fullName') if not @get('id')

    sync: (method, model, options) ->
      if method == "read"
        App.request("communicator:get:code:model", model)
        .done (value) =>
          options.success(value)
          @
        .fail (value) =>
          options.error(value)
          @
      else if method == "update"
        App.request("communicator:update:code:model", model)
        .done (value) =>
          options.success(value)
          @
        .fail (value) =>
          options.error(value)
          @
      else
        Backbone.sync method, model, options

  class Entities.CodeModels extends Entities.Collection
    model: Entities.CodeModel

  App.reqres.setHandler "code:model:entity", (codeObjectName) ->
    new Entities.CodeModel(fullName: codeObjectName)
