@Demo.module "EditorsApp.List", (List, App, Backbone, Marionette, $, _) ->

        class List.Layout extends App.Views.Layout
                template: "editors/list/templates/list_layout"

                regions:
                  panelRegion: "#panel-region"
                  editorsRegion: "#editors-region"

        class List.Editor extends App.Views.ItemView
                template: "editors/list/templates/_editor"
                className: "pry-editor-container"

                onShow: ->
                  domElement = @.$(".pry-editor").get(0)
                  console.log(domElement)
                  editor = ace.edit(domElement)
                  editor.setTheme("ace/theme/tomorrow_night")
                  editor.getSession().setMode("ace/mode/ruby")

        class List.Empty extends App.Views.ItemView
                template: "editors/list/templates/_empty"
                className: "pry-editor-container"

        class List.Loading extends App.Views.ItemView
                template: "editors/list/templates/_loading"

        class List.Editors extends App.Views.CompositeView
                template: "editors/list/templates/_editors"
                itemView: List.Editor
                emptyView: List.Empty
                itemViewContainer: "#editors"