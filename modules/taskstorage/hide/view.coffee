@Air.module 'TaskStorage.TaskHide', (TaskHide, App, Backbone, Marionette, $, _) ->

  class TaskHide.ItemView extends Air.BaseItemView
    template: 'taskstorage/hide/item'

    events:
      'click .hideAction:not(".disabled"), .doneAction:not(".disabled")': 'toggleClass'

    toggleClass: ->
      @$el.find('.hideAction, .doneAction').toggleClass 'disabled'
      @$el.find('.doneBlock, .hideBlock').toggleClass 'hide'

    dialog: ->
      title: 'Закрыть/ Перенести  Задачу'

    initialize: ->
      @task = @options.task

    onShow: ->
      @initComponents()
      @updateUI()
      @bindComment()
      @bindTask()

    initComponents: ->
      @initDatePickers startDate: '+0d'
      @initTimeEntry
        defaultTime  : 'current'
        showSeconds : true

    bindComment: ->
      bindings =
        'message' : '[name="message"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, bindings
      Backbone.Validation.bind @

    bindTask: ->
      bindings =
        date   : '[name="date"]'
        time   : '[name="time"]'
        categoryId: '[name="category"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @task, @el, bindings
      Backbone.Validation.bind @,
        model: @task
