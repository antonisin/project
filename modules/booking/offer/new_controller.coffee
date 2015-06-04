@Air.module 'Booking.Offer', (Offer, App, Backbone, Marionette, $, _) ->
  class Offer.NewController extends App.Base.Controller
    _name: 'booking/offers/new'

    initialize: (opts) ->
      { @booking  } = opts

      @model = App.request 'offer:entity', booking: @booking
      @show @getView()

      @listenTo @booking, 'change', =>
        @model.trigger 'update:validation', @booking
        @view.trigger 'update:validation'

      @listenTo App.vent, 'booking:offers:add', =>
        if @model.get('adultNet') == '' and @model.get('childNet') == '' and @model.get('newbornNet') == ''
          App.execute 'notify:error', App.request('lang:get', 'booking:add:offer:no:net')
        else if @model.get('adultSale') == '' and @model.get('childSale') == '' and @model.get('newbornSale') == ''
          App.execute 'notify:error', App.request('lang:get', 'booking:add:offer:no:sale')
        else if @model.get('code') == ''
           App.execute 'notify:error', App.request('lang:get', 'booking:add:offer:no:code')
        else
          @loading() unless @model.validate()
          @model.save @model.attributes,
            success: (model, data) => @saveSuccess data

      @listenTo App.vent, 'booking:offers:add:force',  =>
        @loading() unless @model.validate()
        @model.save @model.attributes,
          wait   : true
          success: (model, data) => @saveSuccess data
    saveSuccess: (data) ->
      @loading()
      if data?.errors
        @view.trigger 'save:error', data.errors
      else if data?.warnings
        @view.trigger 'save:warning', data.warnings
      else
        App.vent.trigger 'booking:offers:added', @model
        App.execute 'notify:success', App.request('lang:get', 'offer:add:success')

    getView: ->
      @view = new Offer.ItemView
        model: @model
        bookingModel : @booking
      @view

  App.reqres.setHandler 'booking:offers:view:new', (opts) ->
    new Offer.NewController opts
