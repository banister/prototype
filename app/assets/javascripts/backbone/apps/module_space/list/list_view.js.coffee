@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.RubyModules extends App.Views.ItemView

    initialize: (options)->
      @model = @rootModel = options.root_model

    template: "module_space/list/templates/modules"

    onShow: ->
      dataSource = new kendo.data.HierarchicalDataSource
          transport:
            read: (options) =>
              debugger
              if options.data.fullName?
                @rootModel.findModuleByFullName(options.data.fullName)
              else
                options.success _.sortBy(@rootModel.children().toJSON(), (v) -> v.name)

          schema:
            model:
              id: "fullName"

      window.dataSource = dataSource
      @$("#treeview").kendoTreeView
        dataSource: dataSource
                # [
                #   { text: "Furniture", items: [
                #     { text: "Tables & Chairs" },
                #     { text: "Sofas" },
                #     { text: "Occasional Furniture" }
                #   ] },
                #   { text: "Decor", items: [
                #     { text: "Bed Linen" },
                #     { text: "Curtains & Blinds" },
                #     { text: "Carpets" }
                #   ] }
                # ])


#              options.success @model.toJSON()

        dataTextField:["name"]
