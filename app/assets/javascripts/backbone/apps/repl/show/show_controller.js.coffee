@Demo.module "ReplApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends App.Controllers.Base
    initialize: (options) ->
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @replRegion()

      @show @layout

    onClose: ->
      console.info "closing Show.Controller!"

    replRegion: ->
      replView = @getReplView()

      @layout.replRegion.show(replView)

    getReplView: ->
      new Show.Repl

    getLayoutView: ->
      new Show.Layout
