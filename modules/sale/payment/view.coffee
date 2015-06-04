@Air.module 'Sale.Payment', (Payment, App, Backbone, Marionette, $, _) ->

  class Payment.Layout extends Air.BaseLayout
    template: 'sale/payment/layout'
    regions:
      content: '#content'

  class Payment.PaymentView extends Air.BaseItemView
    template: 'sale/payment/payment'