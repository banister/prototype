@Demo.module "EditorsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "editors/list/list_layout"

    regions:
      panelRegion: "#panel-region"
      editorsRegion: "#editors-region"

  # class List.Editor extends App.Views.ItemView
  #   template: "editors/list/_editor"
  #   className: "pry-editor-container"
  #   tagName: "li"
  #   attributes:
  #     "data-row": "1"
  #     "data-col": "1"
  #     "data-sizex": "1"
  #     "data-sizey": "1"

  #   triggers:
  #     "click .editor-header #close-editor": "clicked:close"
  #     "click .editor-header #expand-editor": "clicked:expand"
  #     "click .editor-header #apply-editor" : "clicked:apply"
  #     "click .editor-header #save-editor" : "clicked:save"

  #   onClose: ->
  #     console.log "closing editor"
  #     @editor?.destroy()

  #   onBeforeClose: =>
  #     App.vent.trigger("gridster:remove:widget", @)
  #     # @triggerMethod("gridster:remove:widget", @)
  #     # @stopListening()

  #   addTemporaryErrorMarker: (lineNumber) ->
  #     @editor.moveCursorTo(lineNumber, 1)
  #     @editor.clearSelection()
  #     @editor.session.setBreakpoint(lineNumber, "error_marker")
  #     @editor.scrollToLine(lineNumber, true, true)

  #     fadeOutFunction = ->
  #       @$(".ace_gutter-cell.error_marker").switchClass "error_marker", "",
  #         easing: "easeInOutQuad"
  #         duration: 3000
  #         complete: => @editor.session.clearBreakpoints()

  #     setTimeout(fadeOutFunction, 5000)

  #   onShow: ->
  #     domElement = @$(".pry-editor").get(0)
  #     console.log(domElement)
  #     @editor = ace.edit(domElement)
  #     window.editor = @editor
  #     @editor.setTheme("ace/theme/tomorrow_night")
  #     @editor.getSession().setMode("ace/mode/ruby")

  #     @editor.on "guttermousedown", (e) =>
  #       target = e.domEvent.target

  #       if target.className.indexOf("ace_gutter-cell") == -1
  #         return
  #       if !@editor.isFocused()
  #         return
  #       # if e.clientX > 25 + target.getBoundingClientRect().left
  #       #   return

  #       console.log "e.clientX: ", e.clientX
  #       console.log "getBoundingClientRect().left: ", target.getBoundingClientRect().left

  #       console.log "should have set breakpoint!"
  #       row = e.getDocumentPosition().row
  #       e.editor.session.setBreakpoint(row)
  #       e.stop()

  class List.Empty extends App.Views.ItemView
    template: "editors/list/_empty"
    className: "pry-editor-container"
    tagName: "li"

  class List.Loading extends App.Views.ItemView
    template: "editors/list/_loading"

  class List.Editors extends App.Views.CompositeView
    template: "editors/list/_editors"
    # itemView: App.Components.Editor.Editor
    # emptyView: List.Empty
    itemViewContainer: "#editors"

    buildItemView: (item, ItemViewType, itemViewOptions) ->
      App.request "editor:component",
        pureView: true
        model: item

    initialize: ->
      unless App.vent._events["gridster:remove:widget"]?
        App.vent.on "gridster:remove:widget", (e)=>
          console.log "blergh"
          $(@itemViewContainer).data("gridster").remove_widget(e.$el)
          e.$el.remove()

    appendHtml: (cv, iv)->
      $(cv.itemViewContainer).data('gridster')?.add_widget(iv.el, 1, 1)

    onShow: ->
      $(@itemViewContainer).gridster
        widget_margins: [10, 10]
        draggable:
          handle: ".editor-header, .editor-header > small"

        widget_base_dimensions: [450, 300]
        autogenerate_stylesheet: true

      if @children.length > 0
        for name, view of @children._views
          @appendHtml(@, view)
