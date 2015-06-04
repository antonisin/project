@Air.module 'Lid.TasksBar', (TasksBar, App, Backbone, Marionette, $, _) ->

  class TasksBar.Controller extends App.Base.Controller

    initialize: ->
      @show @getView()

    getView: ->
      new TasksBar.ItemView
