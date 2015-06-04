@Air.module 'TaskStorage.View.Tasks', (Tasks, App, Backbone, Marionette, $, _) ->

  class Tasks.Controller extends App.Base.Controller
    _name: 'taskstorage/view/tasks'

    initialize: ->
      @collection = App.request 'lid:task:storage:collection'

      view = @getView()

      @listenTo App.vent, 'taskstorage:view:tasks:done', (task) =>
        @collection.remove task

      @listenTo App.vent, 'taskstorage:change:category', (id) =>
        @loading()
        @collection.url = Config.routePrefix + 'task/category/' + id
        @collection.fetch
          reset: true
          success: =>
            @loading()
        @collection.sort()

      @listenTo view, 'childview:taskstorage:tasks:is:marked:toggle',(view, model, value) =>
        model.set('isMarked', value)
        @sendXHR 'task/ismarked/' + model.id
        @collection.reset @collection.models

      @listenTo view, 'childview:taskstorage:tasks:is:picked:toggle',(view, model, value) =>
        model.set('isPicked', value)
        @sendXHR 'task/ispicked/' + model.id
        @collection.sort()
        @collection.reset @collection.models

      @listenTo view, 'childview:taskstorage:tasks:hide:task', (view, object) ->
        App.vent.trigger 'taskstorage:task:hide', object.model

      @listenTo view, 'childview:taskstorage:tasks:done:task', (view, object) ->
        App.vent.trigger 'taskstorage:task:done', object.model

      @listenTo view, 'childview:taskstorage:task:lid:link',(view, object) ->
        App.navigate "lid/" + object.model.get('lid').id,
          trigger: true

      @show view,
        loading:
          entities: @collection

    getView: ->
      new Tasks.CompositeView
        collection: @collection
