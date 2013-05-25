@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.RubyModules extends App.Views.ItemView

    initialize: (options)->
      @model = @rootModel = options.root_model

    template: "module_space/list/templates/modules"

    onShow: ->
      dataSource = new kendo.data.HierarchicalDataSource
          transport:
            read: (options) =>
              if options.data.fullName?
                childNode = @rootModel.findModuleByFullName(options.data.fullName)
                childNode.fetch().then (value)->
                  options.success(_.sortBy(value.children().toJSON(), (v) -> v.name))
              else
                options.success _.sortBy(@rootModel.children().toJSON(), (v) -> v.name)

          schema:
            model:
              id: "fullName"
              fullName: "fullName"

      @$("#treeview").kendoTreeView
        dragAndDrop: true
        dataSource: dataSource
        dataTextField:["name"]

      treeView = @$("#treeview").data("kendoTreeView")
      treeView.bind "select", (e)->
        console.log treeView.dataItem("##{e.node.id}")
        window.blah = e.node
