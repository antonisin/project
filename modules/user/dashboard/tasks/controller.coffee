@Air.module 'User.Dashboard.Tasks', (Tasks, App, Backbone, Marionette, $, _) ->

  class Tasks.TasksController extends App.Base.Controller
    _name: 'dashboard/tasks'

    initialize: (opts) ->
      { user } = opts

      @collection = App.request 'dashboard:tasks:collection', 1, null

      view = @getView user

      @listenTo view, 'dashboard:tasks:range:change', (range) =>
        App.request 'dashboard:tasks:collection', range, @collection

      @show view

    getView: (user) ->
      new Tasks.CompositeView
        model: user
        collection: @collection
