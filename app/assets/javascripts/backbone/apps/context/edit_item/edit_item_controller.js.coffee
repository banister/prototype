@Demo.module "ContextApp.EditItem", (EditItem, App, Backbone, Marionette, $, _) ->
  class EditItem.Controller extends App.Controllers.Base
    initialize: (options) ->
      { @region, id } = options.config

      @layout = @getLayoutView()
      model = App.request("object:info:entity", id, "module")

      model.fetch().then (res) =>
        @listenTo @layout, 'show', =>
          @methodsRegion(model)
          @variablesRegion(model)

        @show @layout

    onClose: ->
      console.info "closing EditItem.Controller!"

    methodsRegion: (model)->
      methodsView = @getMethodsView(model)
      @listenTo methodsView, "method:click", @methodClick
      @layout.methodsRegion.show(methodsView)

    variablesRegion: (model)->
      variablesView = @getVariablesView(model)
      @layout.variablesRegion.show(variablesView)

    getLayoutView: ->
      new EditItem.Layout

    getMethodsView: (model)->
      new EditItem.MethodsView
        model: model

    getVariablesView: (model)->
      new EditItem.VariablesView
        model: model

    methodClick: (fullName)->
      App.vent.trigger "edit:event:clicked", fullName
      @layout.dialogRegion.show (new EditItem.DialogView)
