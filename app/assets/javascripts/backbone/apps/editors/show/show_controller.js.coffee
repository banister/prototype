@Demo.module "EditorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  Show.Controller =
    showEditor: (id) ->

      @layout = @getLayoutView()
      @layout.on 'show', =>
        @displayEditor(id)

      App.mainRegion.show @layout

    displayEditor: (id) ->
      model = App.EditorsApp.EditorModels.get(id)
      editorView = @getEditorView(model)
      editorView.on "clicked:close", (e) ->
        App.execute "editors:list"

      @layout.editorRegion.show(editorView)

    getEditorView: (model)->
      new Show.Editor
        model: model

    getLayoutView: ->
      new Show.Layout
