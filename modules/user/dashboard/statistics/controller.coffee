@Air.module 'User.Dashboard.Statistics', (Statistics, App, Backbone, Marionette, $, _) ->

  class Statistics.StatisticsController extends App.Base.Controller
    _name: 'dashboard/statistics'

    initialize: (opts) ->
      { user } = opts

      view = @getView user
      @show view

    getView: (user) ->
      new Statistics.StatisticsView
        model: user
