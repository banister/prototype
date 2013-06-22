@Demo.module "Components.Repl", (Repl, App, Backbone, Marionette, $, _) ->
  class Repl.Controller extends App.Controllers.Base
    initialize: (options) ->
      @contentView = options.view
      @region = options.config.region
      @expressionModels = App.request "expressions:entity"
      @replLayout = @getReplLayoutView()

      @listenTo @replLayout, 'show', =>
        @replRegion()

      @show @replLayout

    onClose: ->
      console.info "closing Repl.Controller!"

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

      @replLayout.replRegion.show(@replView)

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
      new Repl.Expressions
        collection: @expressionModels

    getReplLayoutView: ->
      new Repl.Layout

  App.reqres.setHandler "repl:component", (contentView, options={}) ->
    replController = new Repl.Controller
      view: contentView
      config: options

    replController.replLayout
