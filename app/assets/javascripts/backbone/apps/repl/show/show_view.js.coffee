@Demo.module "ReplApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "repl/show/show_layout"

    regions:
      panelRegion: "#panel-region"
      replRegion: "#repl-region"
