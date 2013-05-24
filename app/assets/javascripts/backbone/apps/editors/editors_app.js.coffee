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
