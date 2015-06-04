@Air.module 'Admin.Monitoring.Subcategory', (Subcategory, App, Backbone, Marionette, $, _) ->
  class Subcategory.ItemView extends Air.BaseItemView
    template    : 'admin/monitoring/subcategory/change'
    _modelBinder: undefined
    events:
      'change input' : (element) -> @model.set('name', element.target.value)

    dialog: ->
      title: if @model.isNew() then "Добавление Субкатегории" else "Редактирование Субкатегории"

    onShow: ->
      @updateUI()

    initialize: ->
      @model.view = @
      Backbone.Validation.bind @