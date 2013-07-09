@Demo.module "ContextApp", (ContextApp, App, Backbone, Marionette, $, _) ->


  API =
    show: (options={}) ->
      new ContextApp.Show.Controller
       config: options

    editItem: (itemName) ->
      new ContextApp.EditItem.Controller
        config:
          itemName: itemName

  App.commands.setHandler "insert:interactor:context:view", (options={}) ->
    API.show(options)

  App.vent.on "edit:event:clicked", (itemName) ->
    API.editItem(itemName)
