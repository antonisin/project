@Air.module 'TaskStorage.TaskDone', (TaskDone, App, Backbone, Marionette, $, _) ->

  class TaskDone.Controller extends App.Base.Controller
    _name: "taskstorage/done"

    initialize: ->
      @view = @getView()

      @listenTo @, 'ready:save', =>
        @save()

      @show @view

    getView: ->
      new TaskDone.ItemView
        model: @model

    save: ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait: true
          success: =>
            @loading()
            @close()
            App.vent.trigger 'taskstorage:view:tasks:done', @options.task
            App.execute 'notify:success', App.request('lang:get', 'task:done:success')
      else
        App.execute 'notify:error', App.request('lang:get', 'validation:error')