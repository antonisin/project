@Air.module 'Accounting.Invoice.Filter', (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Base.Controller
    initialize: ->
      view = @getView()

      @listenTo view, 'submit', (q) ->
        App.vent.trigger 'invoice:filter:submit', q

      @show view

    getView: ->
      new Filter.View
