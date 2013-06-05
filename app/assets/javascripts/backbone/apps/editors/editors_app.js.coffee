@Demo.module "EditorsApp", (EditorsApp, App, Backbone, Marionette, $, _) ->

  class EditorsApp.Router extends Marionette.AppRouter
    appRoutes:
      "editors" : "listEditors"
      "editors/:id" : "showEditor"

  API =
    listEditors: ->
      EditorsApp.List.Controller.listEditors()

    showEditor: (id) ->
      EditorsApp.Show.Controller.showEditor(id)

  App.addInitializer ->
    new EditorsApp.Router
      controller: API

  # Setup our Editor Models
  EditorsApp.EditorModels = new App.Entities.CodeModels

  App.commands.setHandler "editors:add:code:model", (model) ->
    EditorsApp.EditorModels.add model

  App.commands.setHandler "editors:remove:code:model", (model) ->
    EditorsApp.EditorModels.remove model

  App.commands.setHandler "editors:expand:editor", (model) ->
    App.navigate "editors/#{model.id}", trigger: true

  App.commands.setHandler "editors:list", ->
    App.navigate "editors", trigger: true

  App.vent.on "editors:no:code:model:found", (error_info) ->
    API.show

  App.commands.setHandler "create:code:model:and:add:to:editor:collection", (codeObjectName) ->
    App.request("code:model:entity", codeObjectName)
    .done (codeModel) ->
      EditorsApp.EditorModels.add codeModel
    .fail (codeModel) ->
      console.log "can't find code for a code model!"
