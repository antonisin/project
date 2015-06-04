@Air.module 'Admin.Reason.Change', (Change, App, Backbone, Marionette, $, _) ->

  class Change.ItemView extends Air.BaseItemView
    template: 'admin/accounting/reason/edit'
    _modelBinder: undefined

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'fine:reason:add') else App.request('lang:get', 'fine:reason:edit', [@model.id])

    onShow: ->
      @updateUI()
      @$('[name="point"]').inputFilter 'number'
      @bind()

    bind: ->
      @bindings =
        text : '[name="text"]'
        point: '[name="point"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @