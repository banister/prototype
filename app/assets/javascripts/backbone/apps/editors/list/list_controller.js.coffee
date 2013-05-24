@Demo.module "EditorsApp.List", (List, App, Backbone, Marionette, $, _) ->
  List.Controller =
    listEditors: ->

      @layout = @getLayoutView()
      @layout.on 'show', =>
        @showEditors()

      App.mainRegion.show @layout

    showEditors: ->
      editorsView = @getEditorsView()
      @layout.editorsRegion.show(editorsView)

    getEditorsView: ->
      new List.Editors

    getLayoutView: ->
      new List.Layout
