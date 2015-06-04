@Air.module 'Sale.Payment', (Payment, App, Backbone, Marionette, $, _) ->

  class Payment.PaymentController extends App.Base.Controller

    initialize: (opts) ->
      opts.model or= App.request 'sale:entity', id: opts.id
      { @model } = opts
      @layout = @getLayout()

      @listenTo @layout, 'show', =>
        @layout.content.show @getView()

      @show @layout,
        loading:
          entities: [@model]

    getLayout: ->
      new Payment.Layout

    getView: ->
      new Payment.PaymentView model: @model