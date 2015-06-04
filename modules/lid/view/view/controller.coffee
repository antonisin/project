@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.ViewController extends App.Base.Controller
    initialize: (opts)->
      @model  = opts.model
      @layout = @getLayout()
      @layout.on 'show', =>
        @extraEmails()
        @extraPhones()
        @extraLid()

      @show @layout

    extraLid: ->
      controller = new View.ExtraLidController
        model : @model
        region: @layout.extraLids

      @listenTo @ , 'extra:lid:add:view'        , => controller.trigger 'extra:lid:add:controller'
      @listenTo @ , 'model:persisted:controller', => controller.trigger 'refresh:this:view'

    extraEmails: ->
      controller = new View.ExtraEmailsController
        model : @model
        region: @layout.extraEmails

      @listenTo @ , 'extra:add:email:view'      , => controller.trigger 'extra:add:email:controller'
      @listenTo @ , 'model:persisted:controller', => controller.trigger 'refresh:this:view'

    extraPhones: ->
      controller = new View.ExtraPhonesController
        model : @model
        region: @layout.extraPhones

      @listenTo @ , 'extra:add:phone:view'      , => controller.trigger 'extra:add:phone:controller'
      @listenTo @ , 'model:persisted:controller', => controller.trigger 'refresh:this:view'

    getLayout: ->
      view = new View.LidView
        model: @model

      @listenTo view , 'extra:email:add', => @trigger 'extra:add:email:view'
      @listenTo view , 'extra:phone:add', => @trigger 'extra:add:phone:view'
      @listenTo view , 'extra:lid:add'  , => @trigger 'extra:lid:add:view'
      @listenTo view , 'model:persisted', => @trigger 'model:persisted:controller', arguments
      @listenTo view , 'bookings:list'  , => @trigger 'bookings:list:controller', @

      @listenTo App.vent , 'booking:close' , =>
        @trigger 'bookings:new:controller', @
        App.vent.trigger 'model:history:persisted', @model


      view