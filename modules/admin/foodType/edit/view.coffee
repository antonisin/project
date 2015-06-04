@Air.module 'Admin.FoodType.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/foodType/edit'
    _modelBinder: undefined

    bindings:
      name: '[name="name"]'
      code: '[name="code"]'
      systemName: '[name="systemName"]'

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'foodType:title:add') else App.request('lang:get', 'foodType:title:edit', [@model.id])

    onShow: ->
      @updateUI()
      @bind()

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
  