@Air.module 'Accounting.Invoice.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Base.Controller
    _name: 'invoice/list'

    initialize: ->
      @collection = App.request 'invoice:entities'
      @layout = @getLayout()

      @listenTo @layout, 'show', =>
        @showListView()
        @showFilterView()

      @listenTo App.vent, 'invoice:filter:submit', (q) =>
        @collection = App.request 'invoice:filter:entities', q
        @showListView()

      @show @layout,
        loading:
          entities: @collection

    showListView: ->
      view = @getListView()

      @listenToOnce view, 'childview:invoice:item:click', (el, model) =>
        App.vent.trigger 'accounting:invoices:view', model

      @layout.list.show view

    showFilterView: ->
      view = App.request 'filter:invoice:view', @layout.filter

      @layout.filter.show

    getLayout: ->
      new List.Layout

    getListView: ->
      new List.ListView
        collection: @collection
