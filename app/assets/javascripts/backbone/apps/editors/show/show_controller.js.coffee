@Demo.module "EditorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends App.Controllers.Base
    initialize: (options) ->
      { id } = options

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @editorsRegion(id)

      @show @layout

    onClose: ->
      console.info "closing Show.Controller!"

    editorsRegion: (id) ->
      model = App.request "editor:model", id

      editorView = @getEditorView(model)
      @listenTo editorView, "clicked:close", (e) ->
        App.execute "editors:list"

      @layout.editorRegion.show(editorView)

    getEditorView: (model)->
      new Show.Editor
        model: model

    getLayoutView: ->
      new Show.Layout
