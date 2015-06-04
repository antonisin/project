@Air.module 'Admin.Progress.Change', (Change, App, Backbone, Marionette, $, _) ->

  class Change.ItemView extends App.BaseItemView
    template : 'admin/progress/logic'
    templateHelpers: ->
      array: @options.array
      field: @options.field

  class Change.Layout extends Air.BaseLayout
    template: 'admin/progress/change'
    regions :
      types  : '#types'
      ranges : '#ranges'
      values : '#values'

    behaviors:
      SaveModel: {}

    dialog: ->
      title: 'Добавить/Изменить достижение'

    onShow: ->
      @$("#picture").filestyle
        buttonName: "btn-primary"
      @bind()

    bind: ->
      @bindings =
        comment: '[name="comment"]'
        name : '[name="name"]'
        image: '[name="image"]'
        type : '[name="type"]'
        rank : '[name="rank"]'
        range: '[name="range"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
