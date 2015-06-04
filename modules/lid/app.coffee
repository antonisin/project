@Air.module 'Lid', (Lid, App, Backbone, Marionette, $, _) ->

  class Lid.Router extends App.Routers.BaseRouter
    menuItem: 'lid'
    appRoutes:
      'lid'     : 'list'

      'lid/new' : 'create'
      'lid/:id' : 'view'

      'lid/:lid/booking/new'  : 'bookingCreate'
      'lid/:lid/booking/:id'  : 'bookingView' 

  API =
    # routings 
    list: ->
      @listController = new Lid.List.Controller region: @getRegion()

    view: (id, model) ->
      @getView {id: id, model: model}

    create: ->
      @getView {}

    bookingView: (lid, id, model) ->
      @getView {id: lid, booking: id, model: model}

    bookingCreate: (lid) ->
      @getView id: lid

    # internals
    getView: (opts) ->
      new Lid.View.Controller 
        region  : @getRegion()
        id      : opts.id
        model   : opts.model
        booking : opts.booking 

    getRegion: ->
      App.content

  App.addInitializer ->
    new Lid.Router
      controller: API

    App.vent.on 'lid:list:item:click', (model) =>

      @navigate "lid/#{model.id}"
      API.view model.id, model
      
    App.vent.on 'lid:list:item:new', (opts) =>
      @navigate "lid/new", trigger: true

    App.vent.on 'lid:booking:list:item:click', (model) =>
      @navigate "lid/#{model.get('lid')}/booking/#{model.id}"
