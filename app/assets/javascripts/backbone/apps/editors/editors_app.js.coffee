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
    EditorsApp.EditorModels.add model

  App.commands.setHandler "editors:remove:code:model", (model) ->
    EditorsApp.EditorModels.remove model

  EditorsApp.EditorModels = new App.Entities.CodeModels