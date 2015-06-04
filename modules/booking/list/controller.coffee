@Air.module 'Booking.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    _name: 'booking/list'

    initialize: (opts) ->
      @bookings = App.request 'booking:entities', opts.lid
      @view    = @getView()

      @listenTo @view, 'childview:item:click', (el, model)   => App.vent.trigger 'lid:booking:list:item:click', model
      @listenTo @view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'booking:delete:confirm', [model.collection.indexOf(model)+1]),
          (=> @delete model)

      @listenTo App.vent, 'booking:changed', => @bookings.fetch()

      @show @view,
        loading: true

    delete: (model) ->
      model.destroy()

    getView: ->
      new List.ListView
        collection: @bookings

    getMainView: ->
      @view
