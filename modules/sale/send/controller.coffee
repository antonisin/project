@Air.module 'Sale.Send', (Send, App, Backbone, Marionette, $, _) ->
  class Send.SendController extends App.Base.Controller
    _name: 'sale/send'

    initialize: (opts) ->
      { @sale } = opts

      @layout = @getLayout()
      @listenTo @layout, 'show', ->
        @layout.content.show @getPrepareView()

      @emails = App.request 'sale:emails', @sale.get('lidModel').id

      @show @layout,
        loading:
           entities: [@emails]

    getLayout: ->
      new Send.SendLayout

    getFailView: (data) ->
      new Send.SendFailView errors: data.errors

    getSuccessView: (data, emails) ->
      new Send.SendSuccessView 
        model: @sale
        emails: emails

    getPrepareView: ->
      @emails = @emails.get('emails');
      view    = new Send.SendPrepareView {emails: @emails, id: @sale.id}

      @listenTo @layout, 'dialog:click:save', ->
        view.trigger 'sale:send'

      @listenTo view, 'send', (emails) ->
        @loading()
        @sale.trigger 'email:send', emails, ((data) => @sendSuccess data, emails), ((d) => @sendFail d)

      view

    sendSuccess: (data, emails) ->
      @loading()
      @layout.content.show @getSuccessView data, emails
      @layout.trigger 'dialog:button:hide', 'save'
      App.vent.trigger 'sale:disable'

    sendFail: (data) ->
      @loading()
      try
        data = JSON.parse data.responseText 
      catch e
        data = {errors: ['Все настолько ужасно, что я даже не знаю что сломалось']}

      view = @getFailView data
      @layout.content.show view
      @layout.trigger 'dialog:button:hide', 'save'

  App.commands.setHandler 'sale:send', (model) =>
    if model.get('lidModel').email == '' and (not model.get('lidModel').extraEmails or model.get('lidModel').extraEmails == '[]')
      App.execute 'notify:error', App.request('lang:get', 'sale:send:no:emails')
    else
      new Send.SendController
        sale: model
        region: App.dialog
