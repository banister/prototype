@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =
    listModules: ->
      fetching_ruby_modules = App.request "ruby_module:entities"
      modulesView = @getModulesView fetching_ruby_modules
      App.sidebarRegion.show modulesView

    getModulesView: (ruby_modules) ->
      new List.RubyModules
        model: ruby_modules