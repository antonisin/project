@Air.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.InvoiceModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'invoice'

  class Entities.InvoiceCollection extends Entities.BaseCollection
    model: Entities.InvoiceModel
    url: -> Config.routePrefix + 'invoice'

  API =
    getFilteredInvoices: (q) ->
      collection = new Entities.InvoiceCollection
      collection.url = Config.routePrefix + 'invoice/filter'
      collection.fetch
        data: q
      collection

    getInvoice: (id) ->
      invoice = new Entities.InvoiceModel
        id: id
      invoice.fetch()
      invoice

    getInvoices: ->
      collection = new Entities.InvoiceCollection
      collection.fetch()
      collection

  App.reqres.setHandler 'invoice:filter:entities', API.getFilteredInvoices
  App.reqres.setHandler 'invoice:entities', API.getInvoices
  App.reqres.setHandler 'invoice:entity', API.getInvoice
