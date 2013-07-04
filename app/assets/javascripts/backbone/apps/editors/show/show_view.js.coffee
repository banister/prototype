@Demo.module "EditorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "editors/show/show_layout"

    regions:
      contextRegion: ".context-region"
      editorRegion: ".editor-region"
      replRegion: ".repl-region"

  class Show.Editor extends App.Views.ItemView
    template: "editors/show/_editor"
    className: "pry-large-editor-container"

    initialize: (options) ->
      super
      { @width, @height } = options

    triggers:
      "click .editor-header button": "clicked:close"

    onClose: ->
      @editor?.destroy()

    onShow: ->
      @$el.width @width
      @$el.height @height

      domElement = @$(".pry-editor").get(0)
      console.log(domElement)
      @editor = ace.edit(domElement)
      @editor.setTheme("ace/theme/tomorrow_night")
      @editor.getSession().setMode("ace/mode/ruby")

  class Show.Loading extends App.Views.ItemView
    template: "editors/show/_loading"
