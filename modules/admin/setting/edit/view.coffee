@Air.module 'Admin.Settings.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/settings/edit'
    _modelBinder: undefined

    bindings:
      name        : '[name="name"]'
      systemName  : '[name="systemName"]'
      value       : '[name="value"]'

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'setting:title:add') else App.request('lang:get', 'setting:title:edit', [@model.get('systemName')])

    onShow: ->
      @updateUI()
      @bind()

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
  