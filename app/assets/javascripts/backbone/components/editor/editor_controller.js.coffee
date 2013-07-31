@Demo.module "Components.Editor", (Editor, App, Backbone, Marionette, $, _) ->

  class Editor.Controller extends App.Controllers.Base
    initialize: (options) ->
      { @region, @width, @height, id, pureView, model, theme, itemViewOptions }  = options.config

      editorOptions =
        theme: theme

      if model?
        @editorView = @setupEditorView(model, editorOptions, itemViewOptions)
      else
        model = App.request "code:model:entity", id
        model.fetch().done => @setupEditorView(model, editorOptions, itemViewOptions)

      if pureView?
        @listenTo @editorView, 'close', @close
      else
        @show @editorView

    onClose: ->
      console.info "closing Editor.Controller!"

    setupEditorView: (codeModel, editorOptions, itemViewOptions) ->
      editorView = @getEditorView(codeModel, editorOptions, itemViewOptions)

      @listenTo editorView, "clicked:save", @exportEditorContentToFile
      @listenTo editorView, "clicked:apply", @applyEditorContentToCodeModel

      editorView

    # an object literal containing view/model/collection properties is passed
    # to this method, so we must explicitly extract out the view as
    # we do in the first line of this method
    applyEditorContentToCodeModel: (obj) ->
      view = obj.view
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

    exportEditorContentToFile: (obj) ->
      view = obj.view
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

    getEditorView: (model, editorOptions, itemViewOptions) ->
      options = _.extend {model: model, config: editorOptions}, itemViewOptions

      new Editor.Editor(options)

  App.reqres.setHandler "editor:component", (options={}) ->
    editorController = new Editor.Controller
      config: options

    editorController.editorView
