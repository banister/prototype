@Demo.module "Components.Editor", (Editor, App, Backbone, Marionette, $, _) ->

  class Editor.Controller extends App.Controllers.Base
    initialize: (options) ->
      { @region, @width, @height, id, pureView, model, theme }  = options.config

      editorOptions =
        theme: theme

      if model?
        @editorView = @setupEditorView(model, editorOptions)
      else
        model = App.request "code:model:entity", id
        model.fetch().done => @setupEditorView(model, editorOptions)

      if pureView?
        @listenTo @editorView, 'close', @close
      else
        @show @editorView

    # insertSubViews: (codeModel, pureView, res) =>
    #   @listenTo @editorLayout, 'show', =>
    #     console.log "showing @editorLayout"
    #     @editorRegion(codeModel)

    #   if pureView?
    #     @listenTo @editorLayout, 'close', @close
    #   else
    #     @show @editorLayout

    onClose: ->
      console.info "closing Editor.Controller!"

    setupEditorView: (codeModel, editorOptions) ->
      editorView = @getEditorView(codeModel, editorOptions)

      @listenTo editorView, "childview:clicked:save", @exportEditorContentToFile
      @listenTo editorView, "childview:clicked:apply", @applyEditorContentToCodeModel

      editorView

      # @listenTo editorView, "childview:gridster:remove:widget", (view) ->
      #   console.log "trying to remove widget from gridster"
      #   $(@itemViewContainer).data("gridster").remove_widget(view.$el)

      # @editorLayout.editorRegion.show(editorView)

    applyEditorContentToCodeModel: (view) ->
      console.log "trying to apply changes from code model"
      view.model.set code: view.editor.getValue()
      view.model.save()
      .done (model) ->
        toastr.success("Applied changes.", model.fullName)
        view.editor.session.clearBreakpoints()
      .fail (res) ->
        toastr.error("Couldn't apply changes! #{res.error}", view.model.get('fullName'))
        errorLineOffset = view.model.get('nesting').length + 1
        view.addTemporaryErrorMarker(res.error[2] - errorLineOffset)

    exportEditorContentToFile: (view) ->
      view.model.set code: view.editor.getValue()
      view.model.set shouldSaveToFile: true
      view.model.save()
      .done (model) ->
        toastr.success("Saved changes to #{model.originalSourceInfo.sourceLocation[1]}", model.fullName)
        view.editor.session.clearBreakpoints()
      .fail (res) ->
        toastr.error("Couldn't apply changes! #{res.error}", view.model.get('fullName'))
        errorLineOffset = view.model.get('nesting').length + 1
        view.addTemporaryErrorMarker(res.error[2] - errorLineOffset)

    getEditorView: (model, editorOptions) ->
      new Editor.Editor
        model: model
        config: editorOptions

  App.reqres.setHandler "editor:component", (options={}) ->
    editorController = new Editor.Controller
      config: options

    editorController.editorView
