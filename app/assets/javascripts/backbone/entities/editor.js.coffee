@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  # This is the model that backs an Editor view
  class Entities.CodeModel extends Entities.Model

  class Entities.CodeModels extends Entities.Collection
    model: Entities.CodeModel

  App.vent.on "add:code:model:to:editor:collection", (data) ->
    App.request("communicator:get:code_model", data).then (response) ->
      App.execute "editors:add:code:model", new Entities.CodeModel(response)
