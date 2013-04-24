@Demo.module "UsersApp.List", (List, App, Backbone, Marionette, $, _) ->

        List.Controller =
                listUsers: ->
                        fetching_users = App.request "user:entities"

                        @layout = @getLayoutView()
                        @layout.on 'show', =>
                                @showLoading()
                                fetching_users.done (users) =>
                                        @showPanel users
                                        @showUsers users

                        App.mainRegion.show @layout

                showLoading: ->
                        loadingView = @getLoadingView()
                        @layout.usersRegion.show loadingView

                showPanel: (users) ->
                        panelView = @getPanelView users
                        @layout.panelRegion.show panelView

                showUsers: (users) ->
                        usersView = @getUsersView users
                        @layout.usersRegion.show usersView

                getPanelView: (users) ->
                        new List.Panel
                                collection: users

                getUsersView: (users) ->
                        new List.Users
                                collection: users

                getLayoutView: ->
                        new List.Layout

                getLoadingView: ->
                        new List.Loading