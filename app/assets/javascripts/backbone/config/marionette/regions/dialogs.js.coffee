do (Backbone, Marionette) ->
  class Marionette.Region.Dialog extends Marionette.Region

    constructor: ->

    # This is fired after view content is inserted into the region
    # important that this dialog() is called here, as it needs
    # to be called only after view content has been rendered otherwise
    # sizing/rendering errors occur when it's dialogified.
    onShow: (view) ->
      @$el.dialog
        close: (e, ui) =>
          @closeDialog()

    closeDialog: ->
      # note: this closes the entire region (and all nested views)
      # not just the view itself.
      @close()

      # remove all html/css inserted into the page by the dialog widget
      @$el.dialog("destroy")
