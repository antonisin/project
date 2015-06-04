@Air.module 'Accounting.Invoice.View.Sale', (Sale, App, Backbone, Marionette, $, _) ->

  class Sale.Controller extends App.Base.Controller
    initialize: (opts) ->
      collection = App.request 'sale:entities', opts.collection
      @model = opts.model
      @updateModel collection

      view = @getView collection
      @show view

    updateModel: (collection) ->
      @RUB = 0; @USD = 0
      _.filter(collection.models, @getIncomes)

      @model.set
        'incomeRUB' : @RUB
        'incomeUSD' : @USD

    getIncomes: (item) =>
      @RUB += item.get('income') / 100 * @model.get('percent') + @model.get('bonus')
      @USD += item.get('income') / 100 * @model.get('percent') + @model.get('bonus') / window.data['USD']

    getView: (collection) ->
      new Sale.List
        collection: collection
        model: @model
        itemViewOptions:
          percent : @model.get('percent')
          bonus: @model.get('bonus')
