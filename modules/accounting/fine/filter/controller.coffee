@Air.module 'Accounting.Fine.Filter', (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Base.Controller

    initialize: ->
      view = @getView()

      @listenTo view, 'submit', (data, agentId, type) ->
        App.vent.trigger 'filter:submit', data, agentId, type

      @show view

    getView: ->
      new Filter.View
