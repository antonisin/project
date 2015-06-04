@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.HistoryController extends App.Base.Controller
    initialize: (opts) ->
      { @collection } = opts
      view = @getView()

      @show view,
        loading:
          entities: [@collection]

      @listenTo App.vent, 'model:history:change', =>
        @collection.fetch()

      @listenTo App.vent, 'model:history:persisted', =>
        App.vent.trigger 'model:history:change'

    getView: ->
      view = new View.HistoryListView
        collection: @collection

      @listenTo view, 'childview:new:comment', (el, text) =>
        App.vent.trigger 'history:comments:add',
          id: el.model.id
          text: text
      view

