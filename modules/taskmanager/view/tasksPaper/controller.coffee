@Air.module 'Lid.TasksPaper', (TasksPaper, App, Backbone, Marionette, $, _) ->

  class TasksPaper.Controller extends App.Base.Controller
    initialize: ->
      # @todo lidUser
      collection = App.request 'lid:task:paper:collection', @options.tasks
      @view = @getView collection

      @listenTo App.vent, 'task:paper:add:model', (model) =>
        collection.add model

      @listenTo @view, 'childview:task:add:comment', (view, model) =>
        new App.Lid.ChangeTask.AddComment.Controller
          region: App.dialog
          model: App.request 'lid:task:paper:comment:new:model', model.id

      @listenTo @view, 'addTask', ->
        new App.Lid.ChangeTask.Controller
          model : App.request 'lid:task:paper:new:model', @options.lidId
          region: App.dialog

      @listenTo @view, 'lid:task:paper:booking:close', =>
        @listenTo App.vent, 'taskstorage:view:tasks:done', =>
          collection.fetch
            wait:true
            success: =>
              @view = @getView collection
              @show @view

        App.vent.trigger 'taskstorage:task:done', collection.last()

      @show @view

    getView: (collection) ->
      new TasksPaper.CompositeView
        collection: collection
