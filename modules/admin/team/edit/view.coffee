@Air.module 'Admin.Team.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/team/edit'
    _modelBinder: undefined

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'team:title:add') else App.request('lang:get', 'team:title:edit', [@model.id])

    onShow: ->
      @updateUI()
      @bind()

    bind: ->
      @bindings =
        name: '[name="name"]'
        systemName: '[name="systemName"]'
        description: '[name="description"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
  