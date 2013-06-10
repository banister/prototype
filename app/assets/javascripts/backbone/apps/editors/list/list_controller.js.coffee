@Demo.module "EditorsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base
    initialize: ->
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @editorsRegion()

      @show @layout

    onClose: ->
      console.info "closing List.Controller!"

    editorsRegion: ->
      collection = App.EditorsApp.EditorModels
      editorsView = @getEditorsView(collection)

      @listenTo editorsView, "childview:clicked:close", (view) ->
        App.execute "editors:remove:code:model", view.model

      @listenTo editorsView, "childview:clicked:expand", (view) ->
        view.model.set code: view.editor.getValue()
        App.execute "editors:expand:editor", view.model

      @listenTo editorsView, "childview:clicked:save", (view) ->
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

      @listenTo editorsView, "childview:clicked:apply", (view) ->
        console.log "trying to apply changes from code model"
        view.model.set code: view.editor.getValue()
        debugger
        view.model.save()
        .done (model) ->
          toastr.success("Applied changes.", model.fullName)
          view.editor.session.clearBreakpoints()
        .fail (res) ->
          toastr.error("Couldn't apply changes! #{res.error}", view.model.get('fullName'))
          errorLineOffset = view.model.get('nesting').length + 1
          view.addTemporaryErrorMarker(res.error[2] - errorLineOffset)

      @listenTo editorsView, "childview:gridster:remove:widget", (view) ->
        console.log "trying to remove widget from gridster"
        $(@itemViewContainer).data("gridster").remove_widget(view.$el)

      @layout.editorsRegion.show(editorsView)

    getEditorsView: (collection)->
      new List.Editors
        collection: collection

    getLayoutView: ->
      new List.Layout
