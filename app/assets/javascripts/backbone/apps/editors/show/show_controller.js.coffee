@Demo.module "EditorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends App.Controllers.Base
    initialize: (options) ->
      { id } = options

      @model = App.request "editor:model", id

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @replComponent()
        @editorsRegion(id)
        @contextRegion(id)

      @show @layout

    height: 600
    width: 500

    onClose: ->
      console.info "closing Show.Controller!"

    replComponent: ->
      App.request "repl:component", @layout,
        region: @layout.replRegion
        # width: @width
        height: @height

    contextRegion: (id)->
      App.execute "insert:interactor:context:view",
        region: @layout.contextRegion
        id: id

    editorsRegion: (id) ->
      editorView = @getEditorView(@model)
      @listenTo editorView, "clicked:close", (e) ->
        App.execute "editors:list"

      @layout.editorRegion.show(editorView)

    getEditorView: ->
      new Show.Editor
        model: @model
        width: @width
        height: @height

    getLayoutView: ->
      new Show.Layout
