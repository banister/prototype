@Demo.module "EditorsApp.List", (List, App, Backbone, Marionette, $, _) ->
  List.Controller =
    listEditors: ->

      @layout = @getLayoutView()
      @layout.on 'show', =>
        @showEditors()

      App.mainRegion.show @layout

    showEditors: ->
      collection = App.EditorsApp.EditorModels
      editorsView = @getEditorsView(collection)

      editorsView.on "itemview:clicked:close", (e) ->
        App.execute "editors:remove:code:model", e.model

      editorsView.on "itemview:clicked:expand", (e) ->
        App.execute "editors:expand:editor", e.model

      editorsView.on "itemview:clicked:apply", (e) ->
        console.log "trying to apply changes from code model"
        e.model.set code: e.editor.getValue()
        e.model.save()

      editorsView.on "itemview:gridster:remove:widget", (e) ->
        console.log "trying to remove widget from gridster"
        $(@itemViewContainer).data("gridster").remove_widget(e.$el)

      @layout.editorsRegion.show(editorsView)

    getEditorsView: (collection)->
      new List.Editors
        collection: collection

    getLayoutView: ->
      new List.Layout
