@Air.module 'Booking', (Booking, App, Backbone, Marionette, $, _) ->

  API = 

    bookingList: (opts) ->
      new Booking.List.ListController opts
      
    bookingView: (opts) ->
      new Booking.View.ViewController opts

    offersSend: (collection) ->
      new Booking.Offer.MailController
        region: App.dialog
        collection: collection

  App.addInitializer ->

    App.commands.setHandler 'booking:view:list', (opts) =>
      API.bookingList opts
 
    App.commands.setHandler 'booking:view:edit', (opts) =>
      API.bookingView opts

    App.vent.on 'booking:offers:sending', (collection) =>
      API.offersSend collection
