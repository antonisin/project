@Air.module 'Lid.ChangeTask', (ChangeTask, App, Backbone, Marionette, $, _) ->

  class ChangeTask.ItemView extends Air.BaseItemView
    template: 'taskmanager/change'
    _modelBinder: undefined

    dialog: ->
      title: if @options.model.isNew then "Добавление новой задачи" else "Редактирование задачи"

    onShow: ->
      @initComponents()
      @updateUI()
      @bind()

    initComponents: ->
      @initDatePickers startDate: '+0d'
      @initTimeEntry
        defaultTime  : 'current'
        showSeconds : true

    bind: ->
      @bindings =
        message: '[name="message"]'
        date   : '[name="date"]'
        time   : '[name="time"]'
        category: '[name="category"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @