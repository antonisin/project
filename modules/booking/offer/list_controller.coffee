@Air.module 'Booking.Offer', (Offer, App, Backbone, Marionette, $, _) ->

  class Offer.ListController extends App.Base.Controller
    _name: 'booking/offers/list'

    initialize: (opts) ->
      { @bookingModel, @lidId  } = opts

      @collection = App.request 'offer:entities', @bookingModel.id
      @view = @getView @collection

      @listenTo App.vent, 'footer:lid:send:offers', @sendOffers
      @listenTo App.vent, 'footer:lid:create:sale', @createSale

      @listenTo App.vent, 'booking:offers:added', (model) =>
        @collection.add model
        @view.trigger 'highlight', model

      @listenTo App.vent, 'booking:offers:check', =>
        @view.trigger 'check'

      @show @view,
        loading:
          entities: [@collection]

    sendOffers: ->
      offers = @collection.getChosen()
      booking = @options.bookingModel
      nets = booking.get('adults') > 0 or booking.get('newborns') > 0 or booking.get('children') > 0
      if offers.length > 0 and !_.filter(offers, (o) -> o.validationError).length > 0 and nets
        ids = @collection.getSelected()
        if ids.length < offers.length
          App.execute 'notify:error', App.request('lang:get', 'offers:send:error:notsaved')
        else if _.filter(offers, (o) -> !o.get('code')).length > 0
          App.execute 'notify:error', App.request('lang:get', 'offers:send:error:emptycodes')
        else
          App.vent.trigger 'booking:offers:sending', @collection
      else if offers.length > 0 and _.filter(offers, (o) -> o.validationError).length > 0
        App.execute 'notify:error', App.request('lang:get', 'offers:send:error:validation')
      else
        if ( offers.length >0 ) and !nets
          App.execute 'notify:error', App.request('lang:get', 'offers:send:error:validation')
        else
          App.execute 'notify:error', App.request('lang:get', 'offers:send:error:notselected')

    createSale: ->
      offers = @collection.getChosen()
      if offers.length == 0
        App.execute 'show:confirm', App.request('lang:get', 'sale:create:prompt:noselected'), (=>
          if @collection.booking
            App.vent.trigger 'sale:create', {lid: @lidId, booking: @collection.booking}
          else
            App.vent.trigger 'sale:create', {lid: @lidId, booking: @bookingModel.id}
          )
      else if offers.length > 1
        App.execute 'notify:error', App.request('lang:get', 'sale:create:error:morethanoneselected')
      else if not offers[0].get('isSent')
        App.execute 'notify:error', App.request('lang:get', 'sale:create:error:notsent')
      else
        if @collection.booking then booking = @collection.booking else booking = @collection.first().get('booking')
        App.vent.trigger 'sale:create',
          lid     : @lidId,
          booking : booking
          offer   : offers[0].id

    getView: (models) ->
      view = new Offer.ListView
        collection  : models
        labels      : App.request 'offerlabels:entities'
        comments    : App.request 'offercomments:entities'
        itemViewOptions     :
          bookingModel : @bookingModel

      @listenTo view, 'childview:item:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'offer:remove:question') +  (model.collection.indexOf(model) + 1),
          (=>
            model.destroy
              wait: true
              success: =>
                App.vent.trigger 'booking:changed'
            )

      @listenTo view, 'childview:model:sync', => App.vent.trigger 'booking:changed'
      @listenTo view, 'childview:error:not:saved', (view, status, code) => App.execute "notify:#{status}", App.request('lang:get', code)
      view

    getMainView: ->
      @view

  App.reqres.setHandler 'booking:offers:view:list', (opts) ->
    new Offer.ListController opts