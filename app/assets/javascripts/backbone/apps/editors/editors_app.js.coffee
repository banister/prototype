@Demo.module "EditorsApp", (EditorsApp, App, Backbone, Marionette, $, _) ->

  class EditorsApp.Router extends Marionette.AppRouter
    appRoutes:
      "editors" : "listEditors"

  API =
    listEditors: ->
      EditorsApp.List.Controller.listEditors()

  App.addInitializer ->
    new EditorsApp.Router
      controller: API

  App.commands.setHandler "editors:add:code:model", (model) ->
    console.log "got new code model in EditorsApp:", model
    EditorsApp.EditorModels.add model

  EditorsApp.EditorModels = new App.Entities.CodeModels