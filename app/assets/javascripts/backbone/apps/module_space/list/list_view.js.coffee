@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.RubyModules extends App.Views.ItemView

    initialize: (options)->
      @model = @rootModel = options.rootModel

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
        select: (e) ->
          modelData = @dataItem(e.node)
          App.execute "create:code:model:and:add:to:editor:collection", modelData.fullName
