@Air.module 'Lid.ChangeTask.AddComment', (AddComment, App, Backbone, Marionette, $, _) ->

  class AddComment.ItemView extends Air.BaseItemView
    template: 'taskmanager/addcomment'
    dialog: ->
      title: 'Добавление Коменнтария'

    onShow: ->
      @bind()

    bind: ->
      @bindings =
        message: '[name="message"]'
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @