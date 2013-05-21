@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =
    listModules: ->
      fetching_ruby_modules = App.request "ruby_module:entities"

      fetching_ruby_modules.then (value) =>
        modulesView = @getModulesView value.get('children')
        App.sidebarRegion.show modulesView

    getModulesView: (ruby_modules) ->
      new List.RubyModules
        collection: ruby_modules