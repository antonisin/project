@Air.module 'Accounting.Invoice.View', (View, App, Backbone, Marionette, $, _) ->

  class View.DetailsItemView extends Air.BaseItemView
    template: 'accounting/invoice/view/agent/details'

  class View.Layout extends Air.BaseLayout
    template: 'accounting/invoice/view/layout'

    regions:
      'details'           : '#details'
      'saleFines'         : '#saleFines'
      'disciplinaryFines' : '#disciplinaryFines'
      'sales'             : '#sales'
      'scheme'            : '#scheme'

    events:
      'change select': (e) -> @trigger 'details:scheme:change', e
      'click #download' : -> @updateStatus 'invoice:download:action'
      'click #sendEmail': -> @updateStatus 'invoice:send:email:action'
      'click #confirm'  : -> @updateStatus 'invoice:confirm:action'
      'click #reject'   : -> @updateStatus 'invoice:reject:action'

    enableControls: ->
      if @model.get('isConfirmed') or @model.get('isRejected')
        @$el.find('#controls button#download, #controls button#sendEmail').removeClass('disabled')
      else
        @$el.find('#controls button').removeClass('disabled')

    updateStatus: (trigger) ->
      @$el.find('#controls button').addClass('disabled')
      @trigger trigger
