@Air.module 'Accounting.Invoice.View.SaleFine', (SaleFine, App, Backbone, Marionette, $, _) ->

  class SaleFine.Controller extends App.Base.Controller

    initialize: (opts) ->
      { @disabled, @json } = opts
      @collection = App.request 'saleFine:entities', @options.JSON
      @collectionSum()

      view = @getView()
      @show view,
        loading:
          entities: @collection

    collectionSum: ->
      @totals = 0;
      @collection.each (model)=>
        @totals += model.get('value')

    getView: ->
      view = new SaleFine.CompositeView
        collection: @collection
        totals: @totals
        disabled: @disabled

      @listenTo view, 'fines:confirm', ->
        @chosenFines = App.request 'sale:fine:entities:chosen', @collection.getChosen()
        @chosenFines.confirm()

        @markAsConfirmed()
        @collection.chooseNone()
        @updateCollection()

      @listenTo view, 'fines:reject:dialog', ->
        @chosenFines = App.request 'sale:fine:entities:chosen', @collection.getChosen()
        App.vent.trigger 'accounting:invoice:fine:reject', @chosenFines

      @listenTo App.vent, 'fines:reject', (collection) ->
        collection.reject()

        @markAsRejected()
        @collection.chooseNone()
        @updateCollection()

      @listenTo App.vent, 'fines:dialog:close', =>
        @collection.chooseNone()
        @updateCollection()

      @listenTo view, 'choose:all', ->
        @collection.chooseAll()
        @removeOld()

      @listenTo view, 'unchoose:all', ->
        @collection.chooseNone()

      @listenTo view, 'childview:item:choose', (el, model) ->
        @collection.choose model
        @removeOld()

      @listenTo view, 'childview:item:unchoose', (el, model) ->
        @collection.unchoose model
        @removeOld()

      view

    removeOld: ->
      @collection.unchoose @collection.filter (model) -> model.get('isConfirmed') is 1 or model.get('isRejected') is 1

    updateCollection: ->
      @collection.reset @collection.toJSON()

    markAsConfirmed: ->
      _.each @collection.getChosen(), (model) -> model.set 'isConfirmed', 1

    markAsRejected: ->
      _.each @collection.getChosen(), (model) -> model.set 'isRejected', 1
