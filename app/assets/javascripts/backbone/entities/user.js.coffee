@Demo.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

        class Entities.User extends Entities.Model

        class Entities.UsersCollection extends Entities.Collection
                model: Entities.User
                url: Routes.users_path()


        API =
                setCurrentUser: (currentUser) ->
                        new Entities.User currentUser

                getUserEntities: ->
                        defer = $.Deferred()
                        users = new Entities.UsersCollection
                        users.fetch
                                reset: true
                                success: ->
                                        defer.resolve(users)
                        defer.promise()

        App.reqres.setHandler "set:current:user", (currentUser) ->
                API.setCurrentUser currentUser

        App.reqres.setHandler "user:entities", (currentUser) ->
                API.getUserEntities()
