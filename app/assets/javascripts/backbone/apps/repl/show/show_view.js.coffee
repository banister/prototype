@Demo.module "ReplApp.Show", (Show, App, Backbone, Marionette, $, _) ->

        class Show.Layout extends App.Views.Layout
                template: "repl/show/templates/show_layout"

                regions:
                  panelRegion: "#panel-region"
                  replRegion: "#repl-region"

        class Show.Repl extends App.Views.ItemView
                template: "repl/show/templates/_repl"
                className: "repl-container"

                # triggers:
                #   "click .editor-header button": "clicked:close"

                onClose: ->
                  @editor?.destroy()

                onShow: ->
                  domElement = @$(".pry-repl").get(0)
                  console.log(domElement)
                  @editor = ace.edit(domElement)
                  @editor.setTheme("ace/theme/solarized_dark")
                  @editor.getSession().setMode("ace/mode/ruby")

        class Show.Loading extends App.Views.ItemView
                template: "repl/show/templates/_loading"
