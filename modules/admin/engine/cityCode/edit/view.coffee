@Air.module 'Admin.CityCode.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/engine/cityCode/edit'
    _modelBinder: undefined

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'cityCode:title:add') else App.request('lang:get', 'cityCode:title:edit', [@model.id])

    onShow: ->
      @updateUI()
      @$("[name='code'], [name='aditionalNumber']").inputFilter 'number'
      @$("[name='name']").inputFilter 'text'
      @bind()

    bind: ->
      @bindings = 
         name              : '[name="name"]'
         code              : '[name="code"]'
         aditionalNumber   : '[name="aditionalNumber"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @