@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.AirlineModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'airlines'
    defaults    :
      name: ''
      code: ''

  class Entities.AirlineCollection extends Entities.BaseCollection
    model: Entities.AirlineModel
    url: -> Config.routePrefix + "airlines"

  API = 
    getAirline: (data) ->
      new Entities.AirlineModel data

    getAirlines: (data) ->
      collection = new Entities.AirlineCollection data
      collection.fetch()

      collection

  App.reqres.setHandler 'airline:entities', API.getAirlines
  App.reqres.setHandler 'airline:entity', API.getAirline
