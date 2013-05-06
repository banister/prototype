@Demo = do (Backbone, Marionette) ->

        App = new Marionette.Application

        App.rootRoute = Routes.users_path()

        App.addRegions
                headerRegion: "#header-region"
                mainRegion: "#main-region"
                sidebarRegion: "#sidebar-region"
                footerRegion: "#footer-region"

        App.on "initialize:before", (options)->
                @currentUser = App.request "set:current:user", options.currentUser

        App.reqres.setHandler "get:current:user", ->
                App.currentUser

        App.addInitializer ->
                App.module("HeaderApp").start()
                App.module("FooterApp").start()
                App.module("ModulespacesApp").start()

        App.on "initialize:after", ->
                if Backbone.history
                        Backbone.history.start()
                        @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ""

        App