@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  # This is what backs an Editor view
  class Entities.CodeModel extends Entities.Model


  App.vent.on "add:code:model:to:editor:collection", (data) ->
    console.log "data got:", data