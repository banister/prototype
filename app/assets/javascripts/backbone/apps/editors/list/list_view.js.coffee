@Demo.module "EditorsApp.List", (List, App, Backbone, Marionette, $, _) ->

        class List.Layout extends App.Views.Layout
                template: "editors/list/templates/list_layout"

                regions:
                  panelRegion: "#panel-region"
                  editorsRegion: "#editors-region"

        class List.Editor extends App.Views.ItemView
                template: "editors/list/templates/_editor"
                className: "pry-editor-container"
                tagName: "li"

                onShow: ->
                  domElement = @$(".pry-editor").get(0)
                  console.log(domElement)
                  editor = ace.edit(domElement)
                  editor.setTheme("ace/theme/tomorrow_night")
                  editor.getSession().setMode("ace/mode/ruby")

                  @$el.attr('data-row', Math.floor(Math.random() * 3))
                  @$el.attr('data-col', Math.floor(Math.random() * 3))
                  @$el.attr('data-sizex', 1)
                  @$el.attr('data-sizey', 1)

        class List.Empty extends App.Views.ItemView
                template: "editors/list/templates/_empty"
                className: "pry-editor-container"
                tagName: "li"

                onShow: ->
                  # @$el.attr('data-row', 1)
                  # @$el.attr('data-col', 1)
                  # @$el.attr('data-sizex', 2)
                  # @$el.attr('data-sizey', 2)

        class List.Loading extends App.Views.ItemView
                template: "editors/list/templates/_loading"

        class List.Editors extends App.Views.CompositeView
                template: "editors/list/templates/_editors"
                itemView: List.Editor
                emptyView: List.Empty
                itemViewContainer: "#editors"

                onShow: ->
                  $("#editors").gridster
                    widget_margins: [10, 10]
                    extra_rows: 6
                    extra_cols: 3
                    avoid_overlapped_widgets: true
                    draggable:
                      handle: ".editor-header"

                    # widget_base_dimensions: p[200, 400]
                    autogenerate_stylesheet: true
