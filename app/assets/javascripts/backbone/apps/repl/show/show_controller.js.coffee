@Demo.module "ReplApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends App.Controllers.Base
    initialize: (options) ->
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @replComponent()

      @show @layout

    onClose: ->
      console.info "closing Show.Controller!"

    replComponent: ->
      App.request "repl:component", @layout,
        region: @layout.replRegion

    getLayoutView: ->
      new Show.Layout
