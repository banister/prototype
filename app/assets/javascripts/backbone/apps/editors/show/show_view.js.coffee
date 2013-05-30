@Demo.module "EditorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

        class Show.Layout extends App.Views.Layout
                template: "editors/show/templates/show_layout"

                regions:
                  panelRegion: "#panel-region"
                  editorRegion: "#editor-region"

        class Show.Editor extends App.Views.ItemView
                template: "editors/show/templates/_editor"
                className: "pry-large-editor-container"

                triggers:
                  "click .editor-header button": "clicked:close"

                # onBeforeClose: =>
                #   console.log "should be firing gridster:remove:widget event"
                #   App.vent.trigger("gridster:remove:widget", @)

                onShow: ->
                  domElement = @$(".pry-editor").get(0)
                  console.log(domElement)
                  editor = ace.edit(domElement)
                  editor.setTheme("ace/theme/tomorrow_night")
                  editor.getSession().setMode("ace/mode/ruby")

        class Show.Loading extends App.Views.ItemView
                template: "editors/show/templates/_loading"
