@Air.module 'Admin.Consolidator.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/consolidator/edit'
    _modelBinder: undefined

    bindings:
      name: '[name="name"]'
      systemName: '[name="systemName"]'

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'consolidator:title:add') else App.request('lang:get', 'consolidator:title:edit', [@model.id])

    onShow: ->
      @updateUI()
      @bind()

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
  