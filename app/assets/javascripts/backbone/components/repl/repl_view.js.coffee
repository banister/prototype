@Demo.module "Components.Repl", (Repl, App, Backbone, Marionette, $, _) ->

  class Repl.Layout extends App.Views.Layout
    template: "repl/repl_layout"

    regions:
      panelRegion: ".panel-region"
      replRegion: ".repl-region"

  class Repl.Expression extends App.Views.ItemView
    template: "repl/_expression"
    className: "expression-container"
    tagName: "li"
    lineHeight: 18

    initialize: ->
      @nthParentCounter = 0
      super

    ui:
      outputResultArea: ".output-result"
      inputExpressionArea: ".input-expression"
      stdoutOutputArea: ".stdout-output"

    modelEvents:
      "change:expressionResult" : "updateExpressionResult"
      "change:stdoutOutput" : "updateStdoutOutput"

    events:
      "keydown .input-expression" : "keypress"

    isEnterKey: (key) ->
      key is 13

    updateExpressionResult: ->
      @ui.outputResultArea.text @model.get('expressionResult')

    updateStdoutOutput: ->
      @ui.stdoutOutputArea.text @model.get('stdoutOutput')

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

    # Ensure the nthparentCounter is valid, i.e does not go 'below'
    # current editor and does not go 'above' the first editor
    constrainParentCounter: (viewIndex) ->
      if @nthParentCounter < 0
        @nthParentCounter = 0
      else if (viewIndex - @nthParentCounter) < 0
        @nthParentCounter = viewIndex

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

  class Repl.Loading extends App.Views.ItemView
    template: "repl/_loading"

  class Repl.Expressions extends App.Views.CompositeView
    template: "repl/_expressions"
    itemView: Repl.Expression

    # Name of the container for item views
    container = ".expressions"

    itemViewContainer: container

    ui:
      container: container

    initialize: (options) ->
      { @width, @height } = options
      super

    onShow: ->
      @ui.container.width @width
      @ui.container.height @height

    appendHtml: (cv, iv) ->
      super
      _.defer =>
        @ui.container.scrollTop(@ui.container[0].scrollHeight)
