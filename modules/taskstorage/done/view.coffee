@Air.module 'TaskStorage.TaskDone', (TaskDone, App, Backbone, Marionette, $, _) ->

  class TaskDone.ItemView extends Air.BaseItemView
    template: 'taskstorage/done/item'
    className: 'row'

    dialog: ->
      title: 'Закрыть Задачу'

    onShow: ->
      @bind()

    bind: ->
      @bindings =
        'message': '[name="message"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @