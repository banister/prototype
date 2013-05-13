@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.RubyModule extends Entities.Model

  class Entities.RubyModules extends Entities.Collection
    model: Entities.RubyModule


  #    initialize: ->
  #      if Array.isArray(@get('items'))
  #        @set items: new RubyModules(@get('items'))

  #    # @from


  App.reqres.setHandler "ruby_module:entities", ->
    promise = $.Deferred()
    App.request("socket:get:ruby_modules")?.then (value) ->
      promise.resolve(value)

    promise.promise()

    new Entities.RubyModules
      allModules:
              [
                { text: "Furniture"
                items: [
                  { text: "Tables & Chairs"
                  items: [
                    { text: "bug" }
                    { text: "pig" }
                  ] }
                  { text: "Sofas" }
                  { text: "Occasional Furniture" }
                ] },

                { text: "Decor"
                items: [
                  { text: "Bed Linen" }
                  { text: "Curtains & Blinds" }
                  { text: "Carpets" }
                ] }
              ]
