@Demo.module "ContextApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends App.Controllers.Base
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
      console.info "closing Show.Controller!"

    methodsRegion: (model)->
      methodsView = @getMethodsView(model)
      @layout.methodsRegion.show(methodsView)

    variablesRegion: (model)->
      variablesView = @getVariablesView(model)
      @layout.variablesRegion.show(variablesView)

    getLayoutView: ->
      new Show.Layout

    getMethodsView: (model)->
      new Show.MethodsView
        model: model

    getVariablesView: (model)->
      new Show.VariablesView
        model: model
