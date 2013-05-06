@Demo.module "ModulespacesApp", (ModulespacesApp, App, Backbone, Marionette, $, _) ->

  @startWithParent = false

  API =
    listHeader: ->
      ModulespacesApp.List.Controller.listModules()

  ModulespacesApp.on "start", ->
    API.listHeader()
