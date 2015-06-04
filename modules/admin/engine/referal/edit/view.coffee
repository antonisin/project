@Air.module 'Admin.Referal.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/engine/referal/edit'
    _modelBinder: undefined

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'referal:title:add') else App.request('lang:get', 'referal:title:edit', [@model.id])

    onShow: (opts) ->
      @updateUI()
      @bind()

    bind: ->
      @bindings =
        name           : '[name="name"]'
        code           : '[name="code"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @