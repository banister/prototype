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
                attributes:
                  "data-row": "1"
                  "data-col": "1"
                  "data-sizex": "1"
                  "data-sizey": "1"

                triggers:
                  "click .editor-header button": "clicked:close"

                onBeforeClose: =>
                  console.log "should be firing gridster:remove:widget event"
                  App.vent.trigger("gridster:remove:widget", @)
                  # @triggerMethod("gridster:remove:widget", @)
                  # @stopListening()

                onShow: ->
                  domElement = @$(".pry-editor").get(0)
                  console.log(domElement)
                  editor = ace.edit(domElement)
                  editor.setTheme("ace/theme/tomorrow_night")
                  editor.getSession().setMode("ace/mode/ruby")

        class List.Empty extends App.Views.ItemView
                template: "editors/list/templates/_empty"
                className: "pry-editor-container"
                tagName: "li"

        class List.Loading extends App.Views.ItemView
                template: "editors/list/templates/_loading"

        class List.Editors extends App.Views.CompositeView
                template: "editors/list/templates/_editors"
                itemView: List.Editor
                # emptyView: List.Empty
                itemViewContainer: "#editors"

                initialize: ->
                  App.vent.on "gridster:remove:widget", (e)=>
                    console.log "blergh"
                    $(@itemViewContainer).data("gridster").remove_widget(e.$el)
                    e.$el.remove()

                appendHtml: (cv, iv)->
                  $(cv.itemViewContainer).data('gridster')?.add_widget(iv.el, 1, 1)

                onShow: ->
                  $(@itemViewContainer).gridster
                    widget_margins: [10, 10]
                    draggable:
                      handle: ".editor-header"

                    widget_base_dimensions: [450, 300]
                    autogenerate_stylesheet: true
