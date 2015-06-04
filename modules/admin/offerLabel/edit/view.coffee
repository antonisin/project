@Air.module 'Admin.OfferLabel.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/offerLabel/edit'
    _modelBinder: undefined

    bindings:
      name: '[name="name"]'
      systemName: '[name="systemName"]'

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'offerLabel:title:add') else App.request('lang:get', 'offerLabel:title:edit', [@model.id])

    onShow: ->
      @updateUI()
      @bind()

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
  