@Demo.module "EditorsApp.List", (List, App, Backbone, Marionette, $, _) ->
  List.Controller =
    listEditors: ->

      @layout = @getLayoutView()
      @layout.on 'show', =>
        @showEditors()

      App.mainRegion.show @layout

    showEditors: ->
      collection = App.EditorsApp.EditorModels
      # collection = new App.Entities.RubyModules([{}, {}, {}])
      editorsView = @getEditorsView(collection)
      @layout.editorsRegion.show(editorsView)

    getEditorsView: (collection)->
      new List.Editors
        collection: collection

    getLayoutView: ->
      new List.Layout
