@Demo.module "EditorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  Show.Controller =
    showEditor: (id) ->

      @layout = @getLayoutView()
      @layout.on 'show', =>
        @_showEditor(id)

      App.mainRegion.show @layout

    _showEditor: (id) ->
      model = App.EditorsApp.EditorModels.get(id)
      editorView = @getEditorView(model)
      editorView.on "clicked:close", (e) ->
        App.execute "editors:list"

      # editorView.on "itemview:clicked:close", (e) ->
      #   App.execute "editors:remove:code:model", e.model

      # editorView.on "itemview:gridster:remove:widget", (e) ->
      #   console.log "trying to remove widget from gridster"
      #   $(@itemViewContainer).data("gridster").remove_widget(e.$el)


      @layout.editorRegion.show(editorView)

    getEditorView: (model)->
      new Show.Editor
        model: model

    getLayoutView: ->
      new Show.Layout
