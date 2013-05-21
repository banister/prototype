@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.RubyModule extends Entities.Model
    initialize: ->
      if Array.isArray(@get('children'))
        @set children: new Entities.RubyModules(@get('children'))


  class Entities.RubyModules extends Entities.Collection
    model: Entities.RubyModule

  App.reqres.setHandler "ruby_module:entities", ->
    promise = $.Deferred()
    App.request("communicator:get:ruby_modules")?.then (value) ->
      promise.resolve new Entities.RubyModule(value)

    promise.promise()

    # new Entities.RubyModules
    #   allModules:
    #           [
    #             { text: "Furniture"
    #             items: [
    #               { text: "Tables & Chairs"
    #               items: [
    #                 { text: "bug" }
    #                 { text: "pig" }
    #               ] }
    #               { text: "Sofas" }
    #               { text: "Occasional Furniture" }
    #             ] },

    #             { text: "Decor"
    #             items: [
    #               { text: "Bed Linen" }
    #               { text: "Curtains & Blinds" }
    #               { text: "Carpets" }
    #             ] }
    #           ]
