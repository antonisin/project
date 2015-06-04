@Air.module 'TaskStorage.TaskHide', (TaskHide, App, Backbone, Marionette, $, _) ->

  class TaskHide.Controller extends App.Base.Controller
    _name: 'taskstorage/hide'

    modalEvents: ->
      @listenTo @view, 'dialog:click:save', ->
        @preValidate()

    initialize: ->
      @view = @getView()

      @show @view

    getView: ->
      new TaskHide.ItemView
        model: @model
        task: @options.task

    preValidate: ->
      if @view.task.isValid(true) + @view.model.isValid(true)
        @save @view.task
        @save @view.model
      else
        App.execute 'notify:error', App.request('lang:get', 'validation:error')

    save: (model) ->
      @loading()
      model.save model.attributes,
        wait: true
        success: =>
          @loading()
          @close()
          App.execute 'notify:success', App.request('lang:get', 'save:success')
          model.unset 'time'
          model.unset 'date'
