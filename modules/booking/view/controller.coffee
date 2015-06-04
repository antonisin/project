@Air.module 'Booking.View', (View, App, Backbone, Marionette, $, _) ->

  class View.ViewController extends App.Base.Controller
    _name: 'booking/view'

    initialize: (opts) ->
      unless opts.model
        opts.model = if opts.id then App.request 'booking:entity', {id: opts.id, lid: opts.lidId} else App.request 'last:booking:entity', opts.lidId

      { model, lidId } = opts

      @layout = @getLayout()
      @layout.on 'show', =>
        @showBooking model, lidId
        @showMultiway()
        @showStatus model
        @showNewOffer(model) if model.id
        @showOffers model, lidId

      @listenTo model, 'destroy', => @close()

      @show @layout,
        loading:
          entities: [model]

    showBooking: (model, lid) ->
      view = @getView model

      @listenTo model ,'sync', =>
        App.vent.trigger 'model:history:change'

      @listenTo view, 'model:persisted', @bookingPersisted, @
      @listenTo view, 'offer:add', => App.vent.trigger 'booking:offers:add'
      @listenTo view, 'click:send:offers', => App.vent.trigger 'footer:lid:send:offers'
      @listenTo view, 'click:offers:check', => App.vent.trigger 'booking:offers:check'
      @listenTo view, 'click:create:sale', => App.vent.trigger 'footer:lid:create:sale'
      @listenTo App.vent, 'booking:reject', =>
        model.set('status', 6)
        App.vent.trigger 'booking:close'

      @listenTo App.vent, 'booking:offers:sent', (success = true) =>
        App.vent.trigger 'booking:changed' if success
        view.trigger 'offers:sent'

      @listenTo App.vent, 'booking:offers:sending', =>
        view.trigger 'offers:sending'

      @listenTo App.vent, 'booking:changed', =>
        model.fetch
          data: {lid: model.get('lid')}

      @listenTo App.vent, 'booking:offers:added', =>
        @showNewOffer model

      @layout.content.show view

    showStatus: (model) ->
      view = @getStatusView model
      @layout.status.show view

    showMultiway: ->
      new View.Multiway.Controller
        model: @options.model

    showOffers: (model, lidId) ->
      view = App.request 'booking:offers:view:list',
        bookingModel : model
        lidId: lidId
        region: @layout.offers

    showNewOffer: (model) ->
      view = App.request 'booking:offers:view:new',
        booking: model
        region: @layout.newOffer

    getView: (model) ->
      new View.BookingView
        model: model

    getStatusView: (model) ->
      new View.StatusView
        model: model

    getLayout: ->
      new View.Layout

    bookingPersisted: (model) ->
      @showNewOffer model

      App.navigate "lid/#{model.get 'lid'}/booking/#{model.id}"
      App.vent.trigger 'booking:changed'
