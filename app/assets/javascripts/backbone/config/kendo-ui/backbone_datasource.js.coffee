@kendo.Backbone ?= {}

@kendo.Backbone.DataSource = @kendo.data.DataSource.extend
  init: (options) ->
    bbtrans = new window.BackboneTransport(options.model)
    _.defaults options,
      transport: bbtrans
      autoSync: true

    window.kendo.data.DataSource.fn.init.call @, options


class @BackboneTransport
  constructor: (@model)->

  read: (options) ->
    debugger