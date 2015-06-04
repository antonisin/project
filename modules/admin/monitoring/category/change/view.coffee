@Air.module 'Admin.Monitoring.ChangeCategory', (ChangeCategory, App, Backbone, Marionette, $, _) ->
  class ChangeCategory.CategoryItemView extends Air.BaseItemView
    template  : 'admin/monitoring/category/change/item'
    events:
      'change input' : (element) -> @model.set('name', element.target.value)
    modelEvents:
      'change' : -> @trigger 'model:save', @model

    initialize: ->
      @model.view = @

      Backbone.Validation.bind @
