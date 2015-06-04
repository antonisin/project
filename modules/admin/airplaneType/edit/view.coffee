@Air.module 'Admin.AirplaneType.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/airplaneType/edit'
    _modelBinder: undefined

    bindings:
      name: '[name="name"]'
      code: '[name="code"]'

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'airplaneType:title:add') else App.request('lang:get', 'airplaneType:title:edit', [@model.id])

    onShow: ->
      @updateUI()
      @bind()
      @$("[name='name'],[name='code']").inputFilter 'all'

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
  