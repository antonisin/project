@Air.module 'Sale.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditController extends App.Base.Controller
    _name: 'sale/edit'

    initialize: (opts) ->
      unless opts.model
        opts.model = App.request 'sale:entity', id: opts.id

      { @model } = opts
      @listenToOnce opts.model, 'sync', @saved unless @model.id

      @flights = App.request 'flight:entities'
      @passangers = App.request 'passanger:entities'
      @updateCollections()

      @layout = @getLayout()

      @listenTo @layout, 'show', => _.defer(=>
        @updateCollections()
        @layout.instruction.show @getInstructionInitialView()
        @layout.passangers.show @getPassangersView()
        @layout.flights.show @getFlightsView()
        @layout.payment.show @getPaymentPassangers()

        App.vent.trigger 'sale:disable' if @model.get 'isSent'
      )

      @show @layout,
        loading:
          entities: [@model]

      App.vent.trigger 'footer:view:default'

      @listenTo App.vent, 'sale:disable', =>
        @model.trigger 'disable'
        @flights.trigger 'disable'
        @passangers.trigger 'disable'

    getLayout: ->
      view = new Edit.Layout model: @model

      @listenTo view, 'import', @import
      @listenTo view, 'click:send', @send
      view

    getPaymentPassangers: ->
      view = new Edit.PaymentPassangerListView
        collection: @passangers
        payment: @model

      @listenTo view, 'passengers:confirm:all', =>
        Backbone.sync 'create', @passangers,
          url: Config.routePrefix + "passanger/confirm/all"
          error: ->
            App.execute 'notify:info', App.request('lang:get', 'passengers:confirm:error')
          success: =>
            App.execute 'notify:success', App.request('lang:get', 'passengers:confirm:success')
            view.trigger 'passengers:confirmed'
      view

    getInstructionErrorView: (data) ->
      view = new Edit.InstructionErrorItemView
        errors: data

      @listenTo view, 'update:code',  =>
        @layout.instruction.show @getInstructionInfoView()

      @listenTo view, 'show:instructions', =>
        @layout.instruction.show @getInstructionInitialView()
      view

    getInstructionSuccessView: ->
      view = new Edit.InstructionSuccessItemView

      @listenTo view, 'show:instructions', =>
        @layout.instruction.show @getInstructionInitialView()

      view

    getInstructionInfoView: (data) ->
      view = new Edit.InstructionInfoItemView
        warnings: data.warnings

      @listenTo view, 'show:instructions', =>
        @layout.instruction.show @getInstructionInitialView()

      view

    getInstructionInitialView: ->
      view = new Edit.InstructionInitialItemView
      view

    getPassangersView: ->
      view = new Edit.PassangerCollectionView collection: @passangers
      @listenTo view, 'childview:passanger:change', =>
        @model.fetch()
      view

    getFlightsView: ->
      view = new Edit.FlightCompositeView
        collection  : @flights
        model       : @model

      @listenTo view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'offerFlight:delete:confirm', [ model.collection.indexOf(model) + 1]), ->
          App.vent.trigger 'sale:flight:delete', model

      App.vent.on 'sale:flight:delete', (model) ->
        model.destroy
          success: =>
            App.execute 'notify:success', App.request('lang:get', 'sale:flight:delete:success')


      @listenTo view, 'new:flight', @flightAdd, @
      @listenTo App.vent, 'sale:save', => view.trigger 'enable'
      view

    send: ->
      @flightsValidation = !_.some(@flights.models, (m) -> Backbone.Validation.bind(m.view); m.validate())
      if @flights.length != 0 and @passangers.length != 0 and @flightsValidation
        App.execute 'sale:send', @model
      else
        App.execute 'notify:error', App.request('lang:get', 'sale:send:error')

    saved: ->
      App.vent.trigger 'sale:save', @model.id
      @updateCollections()

    import: ->
      @loading()
      @model.trigger 'import', ((d) => @importSuccess d), ((d) => @importFail d)

    importSuccess: (data) ->
      @loading()
      if !data?.warnings
        @layout.instruction.show @getInstructionSuccessView()
      else
        @layout.instruction.show @getInstructionInfoView data

      @model.set data
      @updateCollections()

    importFail: (data) ->
      @loading()
      data = JSON.parse data.responseText
      @model.set 'passangers', ''
      @model.set 'flights', ''
      @updateCollections()
      @layout.instruction.show @getInstructionErrorView(data)
      App.vent.trigger 'page:blur:hide'

    updateCollections: ->
      @flights.reset @model.get('flights')
      @passangers.reset @model.get('passangers')

    flightAdd: ->
      model = App.request 'flight:entity', sale: @model.id
      @flights.add model
