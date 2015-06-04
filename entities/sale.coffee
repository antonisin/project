@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.SaleModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'sale'

    defaults:
      offer           : ''
      user            : ''
      consolidator    : ''
      rate            : ''
      paymentType     : ''
      created         : ''
      isPaid          : 0
      code            : ''
      validator       : ''
      fee             : ''
      income          : 0
      total           : 0
      oneTransaction  : 0
      comment         : ''
      hideRoute       : 0
      showComment     : 0
      hidePersonalData: 0
      paid: ''
      flights: []
      passangers: []
      payment: ''

    initialize: ->
      @listenTo @, 'import', @import
      @listenTo @, 'email:send', @sendEmail

    import: (success, error) ->
      App.execute 'ajax:post',
        url: 'sale/parse',
        data: {id: @id, code: @get('code'), lid: @get('lid'), booking: @get('booking')},
        success: success,
        error: error

    sendEmail: (emails, success, error) ->
      App.execute 'ajax:post',
        url: 'sale/send',
        data: {id: @id, emails: emails},
        success: success,
        error: error

  class Entities.SaleCollection extends Entities.BaseCollection
    model: Entities.SaleModel
    url: -> Config.routePrefix + "sale/list/#{@user}"

    initialize: (models, opts) ->
      @user = opts.user if opts?.user?

  class Entities.OfferSaleModel extends Entities.BaseModel
    model: Entities.OfferSaleModel
    url  :  Config.routePrefix + "static/offer/"

  class Entities.SaleEmails extends Entities.BaseModel
    urlRoot     : Config.routePrefix + "sale/emails/"

    defaults :
        emails: ''

  class Entities.SalePaymentModel

  class Entities.SalePaymentCollection
    model: Entities.SalePaymentModel

  API =
    getEmails: (id) ->
      model = new Entities.SaleEmails
      model.url = Config.routePrefix + "sale/emails/" + id
      model.fetch()
      model

    getSales: (opts) ->
      if opts
        data = new Entities.SaleCollection opts
      else
        data = new Entities.SaleCollection
        data.user = window.data.user.id
        data.fetch()
      data

    getOfferSale: (presale) ->
      data = new Entities.OfferSaleModel
      data.url += presale
      data.fetch()
      data

    getSale: (opts = {}) ->
      if opts.id
        sale = new Entities.SaleModel {id: opts.id}
        sale.fetch()
      else
        opts.user = App.request('get:current:user').id
        sale = new Entities.SaleModel opts

      sale

    getSaleFilter: (q) ->
      user = App.request 'get:current:user'
      sales = new Entities.SaleCollection
      sales.url = Config.routePrefix + "sale/#{user.id}/filter"
      sales.fetch
        data: q

      sales

    getPaymentTypes: ->
      new Entities.SalePaymentCollection window.data['paymentmethods']

  App.reqres.setHandler 'sale:entities', API.getSales
  App.reqres.setHandler 'sale:entity', API.getSale
  App.reqres.setHandler 'sale:emails', API.getEmails
  App.reqres.setHandler 'offer:sale:model:entiti', API.getOfferSale
  App.reqres.setHandler 'sale:entities:filter', API.getSaleFilter
  App.reqres.setHandler 'sale:paymentType:entities', API.getPaymentTypes
