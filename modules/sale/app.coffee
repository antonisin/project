@Air.module 'Sale', (Sale, App, Backbone, Marionette, $, _) ->

  class Sale.Router extends App.Routers.BaseRouter
    menuItem: 'sale'

    appRoutes:
      'sale/payment/:id'  : 'payment'
      'sale/new'          : 'create'
      'sale/:id'          : 'view'
      'sale'              : 'list'

  API =

    list: ->
      @list = new Sale.List.Controller region: @getRegion()

    view: (id, model) ->
      new Sale.Edit.EditController
        id      : id
        model   : model
        region  : @getRegion()

    create: (opts = {}) ->
      App.execute 'show:error', App.request('lang:get', 'sale:create:error:hotlink') unless opts.lid
      App.vent.trigger 'menu:choose', 'sale'
      new Sale.Edit.EditController
        model   : App.request 'sale:entity', opts
        region  : @getRegion()

    payment: (id, model) ->
      @payment = new Sale.Payment.PaymentController 
        model: model
        id: id
        region: @getRegion()

    getRegion: ->
      App.content

  App.addInitializer =>
    new Sale.Router 
      controller: API

    App.vent.on 'sale:list:item:click', (model) ->
      App.navigate "sale/#{model.id}"
      API.view model.id , model

    App.vent.on 'sale:create', (opts) ->
      App.navigate "sale/new"
      API.create opts

    App.vent.on 'sale:save', (id) ->
      App.navigate "sale/#{id}"



