@Air.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.TransferModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'transfer'

    validation:
      amount:
        required: true
        msg: 'Please enter amount'

      description:
        required: true
        msg: 'Please enter description'

      sale:
        required: true

      comment:
        required: true

    defaults:
      agent: ''

  class Entities.TransferCollection extends Entities.BaseCollection
    model: Entities.TransferModel
    url: -> Config.routePrefix + 'transfer'

  API =
    getTransfer: ->
      new Entities.TransferModel

    getTransfers: ->
      collection = new Entities.TransferCollection
      collection.fetch()
      collection

    getFilteredTransfers: (data) ->
      collection = new Entities.TransferCollection
      collection.url = Config.routePrefix + 'transfer/filter'
      collection.fetch
        data: data
      collection

  App.reqres.setHandler 'transfer:entities', API.getTransfers
  App.reqres.setHandler 'transfer:entity', API.getTransfer
  App.reqres.setHandler 'transfer:entities:filter', API.getFilteredTransfers