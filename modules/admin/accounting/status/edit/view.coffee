@Air.module 'Admin.Status.Change', (Change, App, Backbone, Marionette, $, _) ->

  class Change.ItemView extends Air.BaseItemView
    template: 'admin/accounting/status/edit'
    _modelBinder: undefined

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'fine:status:add') else App.request('lang:get', 'fine:status:edit', [@model.id])

    onShow: ->
      @updateUI()
      @bind()

    bind: ->
      @bindings =
        text: '[name="text"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @