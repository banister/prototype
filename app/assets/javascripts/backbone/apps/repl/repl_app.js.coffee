@Demo.module "ReplApp", (ReplApp, App, Backbone, Marionette, $, _) ->

  class ReplApp.Router extends Marionette.AppRouter
    appRoutes:
      "repl" : "showRepl"

  API =
    showRepl: ->
      new ReplApp.Show.Controller

  App.addInitializer ->
    new ReplApp.Router
      controller: API
