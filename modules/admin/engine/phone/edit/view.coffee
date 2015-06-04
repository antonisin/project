@Air.module 'Admin.Phone.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/engine/phone/edit'
    _modelBinder: undefined

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'phone:title:add') else App.request('lang:get', 'phone:title:edit', [@model.id])

    onShow: (opts) ->
      @updateUI()
      @bind()

    templateHelpers : ->
      searchEngines  : window.data['searchEngines']
      cityCodes      : window.data['cityCodes']

    bind: ->
      @bindings = 
        number           : '[name="number"]'
        searchEngine     : '[name="searchEngine"]'
        cityCode         : '[name="cityCode"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @