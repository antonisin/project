@Air.module 'Accounting.Transfer.Filter', (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Base.Controller
    initialize: ->
      view = @getView()

      @show view

    getView: ->
      view = new Filter.View

      @listenTo view, 'submit', (data) ->
        App.vent.trigger 'transfer:filter:submit', data

      @listenTo view, 'transfer:watch', ->
        App.vent.trigger 'transfer:watch:init'

      view