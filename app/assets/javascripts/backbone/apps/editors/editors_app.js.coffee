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

  App.commands.setHandler "editors:add:code:model", (model) ->
    EditorsApp.EditorModels.add model

  App.commands.setHandler "editors:remove:code:model", (model) ->
    EditorsApp.EditorModels.remove model

  App.commands.setHandler "editors:expand:editor", (model) ->
    App.navigate "editors/#{model.id}", trigger: true

  App.commands.setHandler "editors:list", ->
    App.navigate "editors", trigger: true

  EditorsApp.EditorModels = new App.Entities.CodeModels