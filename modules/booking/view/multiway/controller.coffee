@Air.module 'Booking.View.Multiway', (Multiway, App, Backbone, Marionette, $, _) ->

  class Multiway.Controller extends Air.Base.Controller
    _name: 'booking/view/multiway'

    initialize: ->
      collection = App.request 'multiway:entities', @model.get('multiway')

      view = new Multiway.CompositeView
        el: "#multiway"
        collection: collection
