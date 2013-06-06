@Demo.module "ModulespacesApp", (ModulespacesApp, App, Backbone, Marionette, $, _) ->

  @startWithParent = false

  API =
    listHeader: ->
      new ModulespacesApp.List.Controller
        region: App.sidebarRegion

  ModulespacesApp.on "start", ->
    API.listHeader()
