@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

        # class Entities.User extends Entities.Model

        # class Entities.RubyModuleCollection extends Entities.Collection
        #         model: Entities.User
        #         url: Routes.users_path()


        # API =
        #         setCurrentUser: (currentUser) ->
        #                 new Entities.User currentUser

        #         getUserEntities: ->
        #                 defer = $.Deferred()
        #                 users = new Entities.UsersCollection
        #                 users.fetch
        #                         reset: true
        #                         success: ->
        #                                 defer.resolve(users)
        #                 defer.promise()

        # App.reqres.setHandler "set:current:user", (currentUser) ->
        #         API.setCurrentUser currentUser

        class Entities.RubyModules extends Entities.Model

        App.reqres.setHandler "ruby_module:entities", ->
          new Entities.RubyModules
            allModules:
              [
                { text: "Furniture"
                items: [
                  { text: "Tables & Chairs" }
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
