@Air.module 'Accounting.Scheme.Preview', (Preview, App, Backbone, Marionette, $, _) ->

  class Preview.ItemView extends Air.BaseItemView
    template : 'accounting/scheme/preview/item'

    dialog: ->
      title: 'Просмотр схемы: ' + @model.get('schemeName')
