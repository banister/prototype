@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  # This is the model that backs an Editor view
  class Entities.Expression extends Entities.Model
    tryEvaluate: ->
      App.request("communicator:repl:eval", @)
      .done (res) =>
        @set expressionResult: "=> #{JSON.stringify(res)}"

  class Entities.Expressions extends Entities.Collection
    model: Entities.Expression

    appendEmptyExpression: ->
      @push new Entities.Expression({ expressionContent: "" })

  App.reqres.setHandler "expressions:entity", ->
    new Entities.Expressions([ { expressionContent: "" } ])
