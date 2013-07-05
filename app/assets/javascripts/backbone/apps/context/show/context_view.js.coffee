@Demo.module "ContextApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "context/show/show_layout"
    className: "context-container"

    regions:
      methodsRegion: ".methods-region"
      variablesRegion: ".variables-region"

  class Show.MethodsView extends App.Views.ItemView
    template: "context/show/_methods"

  class Show.VariablesView extends App.Views.ItemView
    template: "context/show/_variables"
