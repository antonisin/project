@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Controller extends App.Base.Controller

    initialize: (opts) ->
      { id, model, booking } = opts

      @model or= App.request 'lid:entity', id
      @layout = @getLayout()

      @layout.on 'show', =>
        @lidLayout @model
        @bookingView booking, null, id
        @taskManager()
        @lidHistory id

      @show @layout,
        loading:
          type: 'opacity'
          entities: [@model]

      @listenTo App.vent, 'lid:booking:list:item:click', (model) =>
        @bookingView null, model, id

      @listenTo App.vent, 'lid:booking:new', =>
        @bookingsNew model

      App.vent.trigger 'footer:view:lid', opts.model

    lidHistory: (lidId) ->
      if lidId
        new View.HistoryController
          region: @layout.history
          collection: App.request 'history:entities', @model.id

    lidLayout: (model) ->
      view = @getLidLayout()
      @listenTo view, 'model:persisted:controller', @modelPersisted, @
      @listenTo model, 'sync', (=> App.vent.trigger 'model:history:change') if model.id

      view.on 'bookings:list:controller', @bookingsList, @
      view.on 'bookings:new:controller', @bookingsNew, @

    bookingView: (bookingId, bookingModel, lidId) ->
      if lidId
        view = App.execute 'booking:view:edit',
          model   : bookingModel
          id      : bookingId
          region  : @layout.booking
          lidId   : lidId

    taskManager: ->
      new App.Lid.TasksPaper.Controller
        region: @layout.tasksPaper
        tasks: @model.get 'tasks'
        lidId: @model.id
        lidUser: @model.get('user')

      new App.Lid.SalesPaper.Controller
        region: @layout.salesPaper

      new App.Lid.TasksBar.Controller
        region: @layout.tasksBar
        salesJSON: @model.get('sales')

    bookingsList: (view) ->
      if @layout.bookingsList.currentView
        $(".dataTables_wrapper").remove()
        @layout.bookingsList.close()
      else
        App.execute 'booking:view:list',
          lid     : view.model.id
          region  : @layout.bookingsList

    bookingsNew: (view) ->
      $(".dataTables_wrapper").remove()
      @layout.bookingsList.close()

      App.execute 'booking:view:edit',
        model   : App.request 'booking:entity', lid: view.model.id
        lidId   : view.model.id
        region  : @layout.booking

    modelPersisted: (lid) ->
      lid = lid[0]
      App.navigate "lid/#{lid}"
      @bookingView null, null, lid
      @lidHistory lid
      @trigger 'refresh:lid:layout', lid
      @listenTo @model ,'sync', => App.vent.trigger 'model:history:persisted', lid

    getLayout: ->
      new View.Layout

    getLidLayout:  ->
      new View.ViewController
        region  : @layout.lid
        model: @model
