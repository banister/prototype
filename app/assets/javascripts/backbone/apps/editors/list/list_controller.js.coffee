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

      @listenTo editorsView, "childview:clicked:close", (e) ->
        App.execute "editors:remove:code:model", e.model

      @listenTo editorsView, "childview:clicked:expand", (e) ->
        App.execute "editors:expand:editor", e.model

      @listenTo editorsView, "childview:clicked:apply", (e) ->
        console.log "trying to apply changes from code model"
        e.model.set code: e.editor.getValue()
        e.model.save()
        .done (model) ->
          toastr.success("Applied changes.", model.fullName)
        .fail (res) ->
          toastr.error("Couldn't apply changes! #{res.error}", e.model.get('fullName'))

      @listenTo editorsView, "childview:gridster:remove:widget", (e) ->
        console.log "trying to remove widget from gridster"
        $(@itemViewContainer).data("gridster").remove_widget(e.$el)

      @layout.editorsRegion.show(editorsView)

    getEditorsView: (collection)->
      new List.Editors
        collection: collection

    getLayoutView: ->
      new List.Layout
