@Air.module 'Accounting.Invoice.List', (List, App, Backbone, Marionette, $, _) ->

  class List.FilterView extends Air.BaseItemView

  class List.ItemView extends Air.BaseItemView
    template: 'accounting/invoice/list/item'
    tagName: 'tr'

    events:
      'click td' : -> @trigger 'invoice:item:click', @model

    onShow: ->
      @updateUI()

  class List.EmptyView extends Air.BaseItemView
    template: 'accounting/invoice/list/empty'
    tagName: 'tr'

  class List.ListView extends Air.BaseCompositeView
    template: 'accounting/invoice/list/composite'
    itemView: List.ItemView
    emptyView: List.EmptyView
    itemViewContainer: 'tbody'
