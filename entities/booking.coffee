@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.BookingModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'booking'

    defaults:
      oid: ''
      startDate: ''
      endDate: ''
      adults: 1
      children: 0
      newborns: 0
      comment: ''
      created: ''
      createdFormatted: ''
      lid: ''
      startDelta: ''
      endDelta: ''
      routeType: 1
      isEconom: 0
      isBusiness: 0
      startLocation: ''
      endLocation: ''
      routeTypeModel: {}
      startLocationModel: {}
      endLocationModel: {}

  class Entities.BookingCollection extends Entities.BaseCollection
    model: Entities.BookingModel
    url: -> Config.routePrefix + "lid/#{@lid}/bookings"

    initialize: (models, opts) ->
      @lid = opts.lid if opts?.lid?

  API =
    getBookings: (id) ->
      data = new Entities.BookingCollection []
      data.lid = id
      data.fetch()
      data

    getBooking: (opts) ->
      if opts.id
        booking = new Entities.BookingModel {id: opts.id}
        booking.fetch
          data: {lid: opts.lid}
      else
        booking = new Entities.BookingModel {lid: opts.lid}

      booking

    getBookingStatuses: ->
      new Entities.BookingStatusCollection window.data['bookingstatuses']

    getBookingClasses: ->
      new Entities.BookingStatusCollection window.data['bookingclasses']

    getLastBooking: (lidId) ->
      booking = new Entities.BookingModel {lid: lidId}
      booking.urlRoot = Config.routePrefix + 'booking/last'

      booking.fetch
          data: {lid: lidId}

      booking.urlRoot = Config.routePrefix + 'booking'
      booking

  class Entities.BookingStatusModel extends Entities.BaseModel
  class Entities.BookingStatusCollection extends Entities.BaseCollection
    model: Entities.BookingStatusModel

  class Entities.BookingClassModel extends Entities.BaseModel
  class Entities.BookingClassCollection extends Entities.BaseCollection
    model: BookingClassCollection

  App.reqres.setHandler 'booking:entities', API.getBookings
  App.reqres.setHandler 'booking:entity', API.getBooking
  App.reqres.setHandler 'last:booking:entity', API.getLastBooking
  App.reqres.setHandler 'booking:status:entities', API.getBookingStatuses
  App.reqres.setHandler 'booking:class:entities', API.getBookingClasses