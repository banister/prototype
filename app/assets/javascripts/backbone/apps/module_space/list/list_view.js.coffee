@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Modules extends App.Views.ItemView
    template: "module_space/list/templates/modules"
