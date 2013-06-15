@Demo.module "ReplApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "repl/show/templates/show_layout"

    regions:
      panelRegion: "#panel-region"
      replRegion: "#repl-region"

  class Show.Expression extends App.Views.ItemView
    template: "repl/show/templates/_expression"
    className: "expression-container"
    tagName: "li"
    lineHeight: 18

    modelEvents:
      "change:expressionResult" : "updateExpressionResult"

    events:
      "keydown .input-expression" : "keypress"

    updateExpressionResult: ->
      @$('.output-result').text @model.get('expressionResult')

    keypress: (e) ->
      if e.keyCode == 13
        @resizeEditor()
        @triggerMethod("enter:pressed")

    isLastChild: ->
      @$el.is(":last-child")

    editorHeight: ->
      @editor.session.getLength() * @lineHeight

    resizeEditor: ->
      $(@editor.container).height(@lineHeight + @editorHeight())
      @editor.resize()

    configureEditor: (editor) ->
      editor.setTheme("ace/theme/monokai")
      editor.renderer.setShowGutter(false)
      editor.getSession().setMode("ace/mode/ruby")
      editor.setHighlightActiveLine(false)
      editor.setShowPrintMargin(false)
      editor.getSession().setUseSoftTabs(true)
      editor.getSession().setTabSize(2)

      window.ed = editor

    onShow: ->
      domElement = @$('.input-expression').get(0)
      console.log(domElement)
      @editor = ace.edit(domElement)
      @configureEditor(@editor)
      @editor.focus()

  class Show.Loading extends App.Views.ItemView
    template: "repl/show/templates/_loading"

  class Show.Expressions extends App.Views.CompositeView
    template: "repl/show/templates/_expressions"
    itemView: Show.Expression
    # emptyView: List.Empty
    itemViewContainer: "#expressions"

    collectionEvents:
      "add" : "focusOnGuy"

    focusOnGuy: ->
      @$('.input-expression:last').focus()
