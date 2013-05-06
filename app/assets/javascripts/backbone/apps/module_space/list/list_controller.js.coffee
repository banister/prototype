@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =
    listModules: ->
      modulesView = @getModulesView()
      App.sidebarRegion.show modulesView

    getModulesView: ->
      new List.Modules
