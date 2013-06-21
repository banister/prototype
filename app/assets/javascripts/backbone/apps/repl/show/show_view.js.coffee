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

    initialize: ->
      @nthParentCounter = 0
      super

    ui:
      outputResultArea: ".output-result"
      inputExpressionArea: ".input-expression"

    modelEvents:
      "change:expressionResult" : "updateExpressionResult"

    events:
      "keydown .input-expression" : "keypress"

    isEnterKey: (key) ->
      key is 13

    updateExpressionResult: ->
      @ui.outputResultArea.text @model.get('expressionResult')

    editorChanged: (e) =>
      @resizeEditor()

    editorContent: ->
      @editor.getValue()

    setEditorContent: (content) ->
      @editor.setValue(content)

    editorLength: ->
      @editor.getSession().getLength()

    editorSession: ->
      @editor.getSession()

    editorDocument: ->
      @editorSession().getDocument()

    editorLineAt: (lineNum) ->
      @editorSession().getLine(lineNum)

    evalRepl: ->
      @nthParentCounter = 0
      @trigger("eval:repl")

    onEvalSuccess: ->
      # we remove extraneous new line added after the user has pressed enter
      if @editorLineAt(@editorLength() - 1) is ""
        @editorDocument().removeNewLine(@editorLength() - 2)

    keypress: (e) ->
      @evalRepl() if @isEnterKey(e.which)

    isLastChild: ->
      @$el.is(":last-child")

    editorHeight: ->
      @editor.session.getLength() * @lineHeight

    resizeEditor: ->
      console.log "should be resizing to #{@editorHeight()}"
      $(@editor.container).height(@editorHeight())
      @editor.resize()

    isCursorOnFirstLine: ->
      @editor.getCursorPosition().row is 0

    isCursorOnLastLine: ->
      @editor.getCursorPosition().row >= (@editorLength() - 1)

    insertExpressionHistory: (c) ->
      @cachedContent = @editorContent() if @nthParentCounter is 0
      @nthParentCounter += c
      @trigger "replace:with:other:expression"

    configureEditor: (editor) ->
      editor.setTheme("ace/theme/monokai")
      editor.renderer.setShowGutter(false)
      editor.getSession().setMode("ace/mode/ruby")
      editor.setHighlightActiveLine(false)
      editor.setShowPrintMargin(false)
      editor.getSession().setUseSoftTabs(true)
      editor.getSession().setTabSize(2)
      editor.commands.addCommand
        name: 'evalRepl'
        bindKey:
          win: 'Ctrl-R'
          mac: 'Command-R'
        exec: (e) =>
          @evalRepl()

      editor.commands.addCommand
        name: 'up'
        bindKey: 'Up'
        exec: (editor, args) =>
          if @isCursorOnFirstLine()
            @insertExpressionHistory(1)
          else
            editor.navigateUp(args.times)

      editor.commands.addCommand
        name: 'down'
        bindKey: 'Down'
        exec: (editor, args) =>
          console.log "pressed down"
          if @isCursorOnLastLine()
            @insertExpressionHistory(-1)
          else
            editor.navigateDown(args.times)

      editor.getSession().on 'change', @editorChanged
      window.ed = editor

    onShow: ->
      domElement = @ui.inputExpressionArea.get(0)
      console.log(domElement)
      @editor = ace.edit(domElement)
      @configureEditor(@editor)
      @editor.focus()

  class Show.Loading extends App.Views.ItemView
    template: "repl/show/templates/_loading"

  class Show.Expressions extends App.Views.CompositeView
    template: "repl/show/templates/_expressions"
    itemView: Show.Expression
    itemViewContainer: ".expressions"
