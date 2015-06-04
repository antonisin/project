@Air.module 'User.Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->

  class Dashboard.DashboardController extends App.Base.Controller
    _name: 'dashboard'

    initialize: ->
      userModel = App.request 'get:current:user'
      raceCollection = App.request 'user:entities:race', userModel.id

      @layout = @getLayout()
      
      @listenTo @layout, 'show', => 
        @showHeader userModel
        @showStatistics userModel
        @showTasks userModel
        @showRace userModel, raceCollection

      App.vent.on 'user:decrement', (model) =>
        App.request 'user:decrement:counter', model

      @show @layout,
        loading:
          entities: [userModel, raceCollection]

    showHeader: (user) ->
      new Dashboard.Header.HeaderController
        region  : @layout.header
        user    : user

    showStatistics: (user) ->
      new Dashboard.Statistics.StatisticsController
        region  : @layout.statistics
        user    : user

    showRace: (user, race) ->
      new Dashboard.Race.RaceController
        region  : @layout.race
        user    : user
        race    : race

    showTasks: (user) ->
      new Dashboard.Tasks.TasksController
        region  : @layout.tasks
        user    : user

    getLayout: ->
      new Dashboard.Layout
