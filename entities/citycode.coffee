@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.CityCodeModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'city_code'

    validation:
      name:
        required: true

      code:
        required: true
        pattern: 'number'

      aditionalNumber:
        required: true

  class Entities.CityCodeCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'city_code'
    model: Entities.CityCodeModel

  API = 
    getCityCodeCollection: ->
      collection = new Entities.CityCodeCollection
      collection.fetch()
      collection

    getCityCodeModel: (data) ->
      new Entities.CityCodeModel data

  App.reqres.setHandler 'admin:cityCode:entities', API.getCityCodeCollection
  App.reqres.setHandler 'admin:cityCode:entity', API.getCityCodeModel
