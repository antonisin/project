@Air.module 'Admin.Airline.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template    : 'admin/airline/edit'
    _modelBinder: undefined
    bindings    :
      name: '[name="name"]'
      code: '[name="code"]'

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'airline:title:add') else App.request('lang:get', 'airline:title:edit', [@model.id])

    onShow: ->
      @updateUI()
      @bind()

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @