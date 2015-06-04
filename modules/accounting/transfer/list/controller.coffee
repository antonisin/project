@Air.module 'Accounting.Transfer.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Base.Controller
    initialize: ->
      @layout = @getLayout()

      @collection = App.request 'transfer:entities'

      @listenTo @layout, 'show', =>
        @showFilter()
        @showList()
        @showNew()

      @listenTo App.vent, 'transfer:model:added', (model) =>
        @collection.add model

      @listenTo App.vent, 'transfer:filter:submit', (data) =>
        @filteredCollection = App.request 'transfer:entities:filter', data
        App.execute 'when:fetched', @filteredCollection, =>
          @collection.reset @filteredCollection.toJSON()

      @listenTo App.vent, 'transfer:watch:init', =>
        App.request 'transfer:watch'

      @show @layout,
        loading:
          entities: @collection

    showNew: ->
      App.request 'transfer:new', @layout.new

      @layout.new.show

    showFilter: ->
      App.request 'transfer:filter', @layout.filter

      @layout.filter.show

    showList: ->
      view = @getListView()

      @listenTo view, 'childview:transfer:assign', (el) =>
        App.request 'transfer:assign', el.model

      @layout.list.show view

    getListView: ->
      new List.CompositeView
        collection: @collection

    getLayout: ->
      new List.Layout
