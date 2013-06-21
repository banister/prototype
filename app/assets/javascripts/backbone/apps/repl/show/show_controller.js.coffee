@Demo.module "ReplApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends App.Controllers.Base
    initialize: (options) ->
      @expressionModels = App.request "expressions:entity"
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @replRegion()

      @show @layout

    onClose: ->
      console.info "closing Show.Controller!"

    replaceWithNthParentExpression: (requestingView) =>
      children = @replView.children.toArray()
      viewIndex = children.indexOf(requestingView)
      requestingView.constrainParentCounter(viewIndex)

      console.log "nthParentCounter #{requestingView.nthParentCounter}"

      nthParentView = children[viewIndex - requestingView.nthParentCounter]

      if requestingView.nthParentCounter is 0
        requestingView.setEditorContent requestingView.cachedContent
      else
        requestingView.setEditorContent nthParentView.editorContent()

      requestingView.editor.clearSelection()

    replRegion: ->
      @replView = @getReplView()

      @listenTo @replView, 'childview:eval:repl', @evalRepl
      @listenTo @replView, "childview:replace:with:other:expression", @replaceWithNthParentExpression

      @layout.replRegion.show(@replView)

    evalRepl: (childView) ->
      model = childView.model

      model.set expressionContent: childView.editorContent()

      model.tryEvaluate()
      .done =>
        childView.triggerMethod "eval:success"
        if childView.isLastChild()
          @expressionModels.appendEmptyExpression()

      .fail (failure) ->
        childView.triggerMethod "eval:failure"
        console.log failure

    getReplView: ->
      new Show.Expressions
        collection: @expressionModels

    getLayoutView: ->
      new Show.Layout
