@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.RubyModules extends App.Views.ItemView
    template: "module_space/list/templates/modules"

    onShow: ->
      @$("#treeview").kendoTreeView
        dataSource: new kendo.data.HierarchicalDataSource
          transport:
            read: (options) =>
              v = _.first(@collection.toJSON(), 100)
              console.log "yo yo yo outputting model"
              console.log(v)
              # debugger
              console.log "should have outputted model"
              # debugger
              options.success _.sortBy(@collection.toJSON(), (v) -> v.name)
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

        schema:
          model:
            hasChildren: "has_children"
            text: "name"