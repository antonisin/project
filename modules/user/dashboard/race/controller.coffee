@Air.module 'User.Dashboard.Race', (Race, App, Backbone, Marionette, $, _) ->

  class Race.RaceController extends App.Base.Controller
    _name: 'dashboard/race'

    initialize: (opts) ->
      { user, race } = opts
      agents = race

      @layout = @getLayout()
      @listenTo @layout, 'show', =>
        @showQueue race
        # @showAgents agents
      @show @layout

    getLayout: ->
      new Race.Layout

    showQueue: (collection) ->
      view = new Race.QueueCollectionView collection: collection
      @listenTo view, 'childview:click:profile', (el, model) =>
        App.vent.trigger 'user:profile:view', model

      @layout.queue.show view

    getView: (user) ->
      new Race.RaceView
        model: user
