@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.FlightModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'flight'
    defaults    :
      sale:               ''
      startDate:          ''
      startTime:          '00:00'
      endDate:            ''
      endTime:            '00:00'
      startLocationModel: {}
      endLocationModel:   {}
      startLocation:      ''
      endLocation:        ''
      airline:            ''
      airlineModel:       {}
      name:               ''
      reservationCode:    ''
      reservationCode1:   ''

    validation:
      startDate:
        required: true

      startTime:
        required: true

      endDate:
        required: true

      endTime:
        required: true

      startLocation:
        required: true

      endLocation:
        required: true

      airline:
        required: true

      name:
        required: true

      reservationCode:
        required: true

  class Entities.FlightCollection extends Entities.BaseCollection
    model: Entities.FlightModel
    url: -> Config.routePrefix + "/flights"

  API =
    getFlight: (data) ->
      new Entities.FlightModel data

    getFlights: (data) ->
      new Entities.FlightCollection data

  App.reqres.setHandler 'flight:entities', API.getFlights
  App.reqres.setHandler 'flight:entity', API.getFlight
