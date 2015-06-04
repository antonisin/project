@Air.module 'Accounting.Transfer.List', (List, App, Backbone, Marionette, $, _) ->

  class List.EmptyView extends App.BaseItemView
    template: 'accounting/transfer/list/empty'
    tagName: 'tr'

  class List.ItemView extends App.BaseItemView
    template: 'accounting/transfer/list/item'
    tagName: 'tr'

    initialize: ->
      @model.set('order', @model.collection.indexOf(@model) + 1)

    triggers:
      'click .assign': 'transfer:assign'

  class List.CompositeView extends App.BaseCompositeView
    template: 'accounting/transfer/list/composite'
    itemView: List.ItemView
    emptyView: List.EmptyView
    itemViewContainer: 'tbody'
    className: 'transferTable table table-striped table-bordered table-hover table-full-width'
    tagName: 'table'
    renderOrder: 'DESC'

    initialize: ->
      super
      @listenTo @collection, 'sync', -> @render()
      @listenTo @collection, 'add', -> @render()
