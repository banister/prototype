@Demo = do (Backbone, Marionette, SocketAdapter) ->

        App = new Marionette.Application

        App.rootRoute = "/editors"
        App.socketURL = "ws://127.0.0.1:3001/"
        App.SocketAdapter = new SocketAdapter(App.vent, App.reqres, App.socketURL)

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


        App.vent.on "socket:value", (data) ->
          console.log data
          $("#socket-region").html(data)

        App