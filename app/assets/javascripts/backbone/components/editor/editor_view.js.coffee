@Demo.module "Components.Editor", (Editor, App, Backbone, Marionette, $, _) ->

  class Editor.Layout extends App.Views.Layout
    template: "editor/editor_layout"

    regions:
      panelRegion: ".panel-region"
      editorRegion: ".editor-region"

  class Editor.Editor extends App.Views.ItemView
    template: "editor/_editor"
    className: "pry-large-editor-container"

    initialize: (options) ->
      super
      { config } = options

      @theme = "ace/theme/#{config.theme ? 'tomorrow_night'}"

    triggers:
      "click .editor-header button[data-button-type='close']": "clicked:close"
      "click .editor-header button[data-button-type='expand']": "clicked:expand"
      "click .editor-header button[data-button-type='apply']" : "clicked:apply"
      "click .editor-header button[data-button-type='save']" : "clicked:save"

    onClose: ->
      console.log "closing editor #{@cid}"
      @triggerMethod("closing:baby")
      @editor?.destroy()

    onBeforeClose: =>
      console.log "xxx pig"
      # console.log "closing up in this bitch"
      # @triggerMethod("fuck")
      # App.vent.trigger("gridster:remove:widget", @)
      # @triggerMethod("gridster:remove:widget", @)
      # @stopListening()

    addTemporaryErrorMarker: (lineNumber) ->
      @editor.moveCursorTo(lineNumber, 1)
      @editor.clearSelection()
      @editor.session.setBreakpoint(lineNumber, "error_marker")
      @editor.scrollToLine(lineNumber, true, true)

      fadeOutFunction = ->
        @$(".ace_gutter-cell.error_marker").switchClass "error_marker", "",
          easing: "easeInOutQuad"
          duration: 3000
          complete: => @editor.session.clearBreakpoints()

      setTimeout(fadeOutFunction, 5000)

    onShow: ->
      domElement = @$(".pry-editor").get(0)
      console.log(domElement)
      @editor = ace.edit(domElement)
      window.editor = @editor
      @editor.setTheme(@theme)
      @editor.getSession().setMode("ace/mode/ruby")

      @editor.on "guttermousedown", (e) =>
        target = e.domEvent.target

        if target.className.indexOf("ace_gutter-cell") == -1
          return
        if !@editor.isFocused()
          return
        # if e.clientX > 25 + target.getBoundingClientRect().left
        #   return

        console.log "e.clientX: ", e.clientX
        console.log "getBoundingClientRect().left: ", target.getBoundingClientRect().left

        console.log "should have set breakpoint!"
        row = e.getDocumentPosition().row
        e.editor.session.setBreakpoint(row)
        e.stop()
