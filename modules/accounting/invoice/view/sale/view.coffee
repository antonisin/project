@Air.module 'Accounting.Invoice.View.Sale', (Sale, App, Backbone, Marionette, $, _) ->

  class Sale.Item extends Air.BaseItemView
    template: 'accounting/invoice/view/sale/item'
    tagName: 'tr'

    templateHelpers: ->
      percent: @options.percent
      bonus: @options.bonus

    initialize: ->
      @model.set('order', @model.collection.indexOf(@model) + 1)

    onShow: ->
      @updateUI()

  class Sale.Empty extends Air.BaseItemView
    template: 'accounting/invoice/view/sale/empty'
    tagName: 'tr'

    onShow: ->
      @updateUI()

  class Sale.TotalItemView extends Air.BaseItemView
    template: 'accounting/invoice/view/sale/total'
    tagName : 'tr'

  class Sale.List extends Air.BaseCompositeView
    template : 'accounting/invoice/view/sale/list'
    itemView : Sale.Item
    emptyView: Sale.Empty
    itemViewContainer: 'tbody'

    onShow: ->
      @updateUI()
      @appendView(new Sale.TotalItemView({model:@options.model}))
