@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

        class Entities.Header extends Entities.Model

        class Entities.HeaderCollection extends Entities.Collection
                model: Entities.Header

        API =
                getHeaders: ->
                        new Backbone.Collection [
                                { name: "Stats" }
                                { name: "Android" }
                                { name: "Applications" }
                        ]


        App.reqres.setHandler "header:entities", ->
                API.getHeaders()