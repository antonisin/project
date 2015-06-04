@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.OfferModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'offer'
    defaults:
      adultNet: ''
      adultSale: ''
      childNet: ''
      childSale: ''
      newbornNet: ''
      newbornSale: ''
      created: ''
      code: ''
      label: '1'
      labelColor: '1'
      customLabel: null
      customComment: null
      comments: '[]'
      booking: ''
      createdFormatted: ''
      total:   ''

    _validationDefault:
      required: true
      range: [1, 99999]
      pattern : /^[1-9]\d*[\.,]?\d*$/g

    initialize: ->
      new Backbone.Chooser @
      @listenTo @, 'sent', => @set 'isSent', true
      @listenTo @, 'update:validation', @updateValidation
      super

    updateValidation: (booking) ->
      @validation =
        code:
          required: true
      @validation.adultNet = @validation.adultSale = @_validationDefault     if booking.get('adults')   > 0
      @validation.childNet = @validation.childSale = @_validationDefault     if booking.get('children') > 0
      @validation.newbornNet = @validation.newbornSale = @_validationDefault if booking.get('newborns') > 0

  class Entities.OfferCollection extends Entities.BaseCollection
    model: Entities.OfferModel
    url: -> Config.routePrefix + "booking/#{@booking}/offers"

    initialize: (models, opts) ->
      super
      new Backbone.MultiChooser(@)
      @booking = opts.booking if opts?.booking?
      @listenTo @, 'email:validate', @validateEmail
      @listenTo @, 'email:send', @sendEmail

    validateEmail: (success, error) ->
      App.execute 'ajax:post',
        url: 'booking/validateoffers',
        data: {offers: @getSelected()},
        success: success,
        error: error

    sendEmail: (emails, success, error) ->
      App.execute 'ajax:post',
        url: 'sale/sendoffers',
        data: {presale: @presale, emails: emails},
        success: success,
        error: error

    getSelected: ->
      _.filter _.flatten(_.pluck @getChosen(), 'id'), (e) -> e

  # Related classes

  class Entities.OfferCommentModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'offercomment'
    validation:
      name:
        required: true

      systemName:
        required: true


  class Entities.OfferLabelModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'offerlabel'

    validation:
      name:
        required: true

      systemName:
        required: true

  class Entities.OfferLabelsCollection extends Entities.BaseCollection
    model   : Entities.OfferLabelModel
    url     : Config.routePrefix + 'offerlabel'

  class Entities.OfferCommentsCollection extends Entities.BaseCollection
    model   : Entities.OfferCommentModel
    url     : Config.routePrefix + 'offercomment'

  class Entities.OfferColorModel extends Entities.BaseModel

  class Entities.OfferColorsCollection extends Entities.BaseCollection
    model   : Entities.OfferColorModel

  API =
    getOffers: (id) ->
      data = new Entities.OfferCollection()
      data.booking = id
      data.fetch() if id
      data

    getOffer: (opts) ->
      if opts.id
        offer = new Entities.OfferModel {id: opts.id}
        offer.fetch()
      else
        { booking } = opts
        offer = new Entities.OfferModel {booking: booking.id}
        # offer.trigger 'update:validation', booking

      offer

    getOfferLabels: ->
      new Entities.OfferLabelsCollection window.data['offerlabels']

    getOfferComments: ->
      new Entities.OfferCommentsCollection window.data['offercomments']

    getOfferColors: ->
      new Entities.OfferColorsCollection window.data['offercolors']

    getOfferComment: (data) ->
      new Entities.OfferCommentModel data

    getOfferLabel: (data) ->
      new Entities.OfferLabelModel data


  App.reqres.setHandler 'offer:entities', API.getOffers
  App.reqres.setHandler 'offer:entity', API.getOffer

  App.reqres.setHandler 'offerlabel:entity', API.getOfferLabel
  App.reqres.setHandler 'offerlabels:entities', API.getOfferLabels
  App.reqres.setHandler 'offercomment:entity', API.getOfferComment
  App.reqres.setHandler 'offercomments:entities', API.getOfferComments
  App.reqres.setHandler 'offercolors:entities', API.getOfferColors

