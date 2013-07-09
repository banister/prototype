@Demo.module "ContextApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "context/show/show_layout"
    className: "context-container"

    regions:
      methodsRegion: ".methods-region"
      variablesRegion: ".variables-region"
      dialogRegion: Marionette.Region.Dialog.extend el: ".dialog-region"

  class Show.MethodsView extends App.Views.ItemView
    template: "context/show/_methods"

    events:
      "click a" : "handleClick"

    handleClick: (e) ->
      @trigger "method:click", $(e.target).data("fullname")

  class Show.VariablesView extends App.Views.ItemView
    template: "context/show/_variables"

  class Show.DialogView extends App.Views.ItemView
    template: "context/show/_dialog"
