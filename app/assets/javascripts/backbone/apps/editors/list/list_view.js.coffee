  @Demo.module "EditorsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
      template: "editors/list/list_layout"

      regions:
        panelRegion: "#panel-region"
        editorsRegion: "#editors-region"

    class List.Empty extends App.Views.ItemView
      template: "editors/list/_empty"
      className: "pry-editor-container"
      tagName: "li"

    class List.Loading extends App.Views.ItemView
      template: "editors/list/_loading"

    class List.Editors extends App.Views.CompositeView
      template: "editors/list/_editors"
      itemViewContainer: "#editors"
      itemViewOptions:
        tagName: "li"
        attributes:
          "data-row": "1"
          "data-col": "1"
          "data-sizex": "1"
          "data-sizey": "1"

      buildItemView: (item, ItemViewType, itemViewOptions) ->
        view = App.request "editor:component",
          pureView: true
          model: item
          itemViewOptions: itemViewOptions

        console.log "creating view #{view.cid}"
        @listenTo @, "childview:closing:baby", ->
          console.log "closing baby!"
        @listenTo view, "close", ->
          console.log "editor child view closing!!"

        view

      initialize: ->
        # @listenTo "childview:on:before:close", ->
        #   console.log "editor child view closing!!"

        # unless App.vent._events["gridster:remove:widget"]?
        #   App.vent.on "gridster:remove:widget", (e)=>
        #     console.log "blergh"
        #     $(@itemViewContainer).data("gridster").remove_widget(e.$el)
        #     e.$el.remove()

      appendHtml: (cv, iv)->
        $(cv.itemViewContainer).data('gridster')?.add_widget(iv.el, 1, 1)

      # onItemRemoved: (itemView) ->
      #   $(@itemViewContainer).data("gridster").remove_widget itemView.$el

      onShow: ->
        $(@itemViewContainer).gridster
          widget_margins: [10, 10]
          draggable:
            handle: ".editor-header, .editor-header > small"

          widget_base_dimensions: [450, 300]
          autogenerate_stylesheet: true

        if @children.length > 0
          for name, view of @children._views
            @appendHtml(@, view)
