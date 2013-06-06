@Demo.module "ModulespacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options) ->
      fetching_ruby_modules = App.request "ruby:module:entities", "Object"

      fetching_ruby_modules.then (value) =>
        modulesView = @getModulesView value
        @show modulesView

    getModulesView: (ruby_modules) ->
      new List.RubyModules
        rootModel: ruby_modules