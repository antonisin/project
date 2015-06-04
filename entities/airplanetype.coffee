@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.AirplaneTypeModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'airplaneTypes'
    defaults    :
      name: ''
      code: ''
    validation:
      name:
        required: true
        rangeLength: [2, 200]
      code:
        required: true
        rangeLength: [2, 20]

  class Entities.AirplaneTypeCollection extends Entities.BaseCollection
    model: Entities.AirplaneTypeModel
    url: -> Config.routePrefix + "airplaneTypes"

  API = 
    getAirplaneType: (data) ->
      new Entities.AirplaneTypeModel data

    getAirplaneTypes: (data) ->
      collection = new Entities.AirplaneTypeCollection data
      collection.fetch()

      collection

  App.reqres.setHandler 'airplaneType:entities', API.getAirplaneTypes
  App.reqres.setHandler 'airplaneType:entity', API.getAirplaneType
