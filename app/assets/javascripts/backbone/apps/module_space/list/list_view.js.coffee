@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.RubyModules extends App.Views.ItemView
    template: "module_space/list/templates/modules"

    onShow: ->
      @$("#treeview").kendoTreeView
        dataSource: @model.get('allModules')
