@Air.module 'Booking.Offer', (Offer, App, Backbone, Marionette, $, _) ->

   class Offer.MailController extends App.Base.Controller
    _name: 'booking/offers/mail'
    success: false

    initialize: (opts) ->
      { @collection } = opts
      @layout = @getLayout()
      @listenTo @layout, 'show', =>
        @loading()

      @listenTo @layout, 'modal:hidden', @onDialogClose

      @show @layout

      @collection.trigger 'email:validate', ((d) => @validateSuccess d), ((d)=> @validateError d)

    onDialogClose: ->
      App.vent.trigger 'booking:offers:sent', @success

    validateSuccess: (data) ->
      @loading()
      @layout.trigger 'dialog:button:show', 'save'
      @layout.content.show @getValidateSuccessView(data)
      
    validateError: (data) ->
      @loading()
      try
        data = JSON.parse data.responseText 
      catch e
        data = {errors: null}
      
      @layout.content.show @getValidateErrorView(data.errors)
      App.vent.trigger 'booking:offers:sent', false

    sendSuccess: (data) ->
      @loading()
      _.invoke @collection.getChosen(), 'trigger', 'sent'

      @layout.content.show @getSendSuccessView data
      @layout.trigger 'dialog:button:show', 'close'
      @success = true

    sendError: (data) ->
      @loading()
      @layout.content.show @getSendErrorView()
      @layout.trigger 'dialog:button:show', 'close'
      App.vent.trigger 'booking:offers:sent', false
      
    send: (emails) ->
      if emails.length is 0
        App.execute 'notify:error', App.request('lang:get', 'offers:send:error:noemails')
      else
        @loading()
        @layout.trigger 'dialog:button:hide', 'save'
        @layout.trigger 'dialog:button:hide', 'close'
        @collection.trigger 'email:send', emails, ((d) => @sendSuccess d), ((d)=> @sendError d)            

    getLayout: ->
      new Offer.MailLayout

    getValidateSuccessView: (data) ->
      @collection.presale = data.presale

      view = new Offer.MailSuccessView 
        emails: data.emails
        previewUrl: Config.routePrefix + "sale/preview/#{data.presale}"

      @listenTo view, 'send', @send
      @listenTo @layout, 'dialog:click:save', => view.trigger 'click:send'

      view

    getValidateErrorView: (data) ->
      new Offer.MailErrorView errors: data

    getSendSuccessView: (data) ->
      new Offer.MailSendSuccessView
        emails: data.emails
        previewUrl: Config.routePrefix + "sale/preview/#{@collection.presale}"

    getSendErrorView: (data) ->
      new Offer.MailSendErrorView