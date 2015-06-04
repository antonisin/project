@Air.module 'TaskStorage', (TaskStorage, App, Backbone, Marionette, $, _) ->

  class TaskStorage.Router extends App.Routers.BaseRouter
    menuItem: 'taskstorage'
    appRoutes:
      'taskstorage' : 'view'

  API =
    view: ->
      new TaskStorage.View.Controller
        region: App.content

    done: (model, task) ->
      new TaskStorage.TaskDone.Controller
        region: App.dialog
        task: task
        model: model

    hide: (model, task) ->
      new TaskStorage.TaskHide.Controller
        region: App.dialog
        model: model
        task: task

  App.addInitializer ->
    new TaskStorage.Router
      controller: API

    App.vent.on 'taskstorage:task:hide', (task) ->
      model = App.request 'lid:task:paper:comment:new:model', task.id
      API.hide model, task

    App.vent.on 'taskstorage:task:done', (task) ->
      model = App.request 'lid:task:paper:comment:done:model', task.id
      API.done model, task
