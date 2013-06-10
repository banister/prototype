#= require jquery
#= require jquery.ui.all
#= require lib/underscore
#= require lib/underscore.string.min
#= require lib/jquery.gridster.min
#= require lib/toastr
#= require lib/backbone
#= require lib/bacon
#= require lib/marionette
#= require_tree ../../../app/assets/javascripts/lib/ace
#= require lib/socket_adapter
#= require js-routes
#= require kendo/kendo.web.min
#= require_tree ../../../app/assets/javascripts/backbone/config
#= require backbone/app
#= require_tree ../../../app/assets/javascripts/backbone/controllers
#= require_tree ../../../app/assets/javascripts/backbone/views
#= require_tree ../../../app/assets/javascripts/backbone/entities
#= require_tree ../../../app/assets/javascripts/backbone/apps

describe "Entities.RubyModule", ->
  it "sets id to fullName", ->
    mod = new Demo.Entities.RubyModule fullName: "Henry"
    mod.get('id').should.equal mod.get('fullName')
