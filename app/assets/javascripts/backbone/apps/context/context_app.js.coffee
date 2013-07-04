@Demo.module "ContextApp", (ContextApp, App, Backbone, Marionette, $, _) ->

  App.commands.setHandler "insert:interactor:context:view", (options={}) ->
     new ContextApp.Show.Controller
      config: options
