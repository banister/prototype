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

    replaceWithNthParentExpression: (requestingView, nth) =>
      nthParentView = @replView.nthParentView(requestingView, nth)
      requestingView.setEditorContent nthParentView.editorContent()

    replRegion: ->
      @replView = @getReplView()

      @listenTo @replView, 'childview:eval:repl', @evalRepl
      @listenTo @replView, "childview:replace:with:other:expression", @replaceWithNthParentExpression

      @layout.replRegion.show(@replView)

    evalRepl: (childView) ->
      editor = childView.editor
      model = childView.model

      model.set expressionContent: editor.getValue()

      model.tryEvaluate()
      .done =>
        if childView.isLastChild()
          @expressionModels.push App.request "new:expression:entity"

      .fail (failure) ->
        console.log failure

    getReplView: ->
      new Show.Expressions
        collection: @expressionModels

    getLayoutView: ->
      new Show.Layout
