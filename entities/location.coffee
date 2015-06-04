@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.LocationModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'locations'
    defaults    :
      code:    ''
      country: ''
      is_city: 1
      name_ru: ''
      name_en: ''
      city   : ''

    validation:
      code:
        required: true
        msg     : 'Please enter a valid code'
      
      country:
        required: true
        msg     : 'Please enter a valid country'
      
      is_city:
        required: true
        msg     : 'Please select airport or city'

      name_ru:
        required: true
        msg     : 'Please select a valid name ru'
      
      name_en:
        required: true
        msg     : 'Please select a valid name en'

      city:
        required: false
        msg     : 'Please enter a valid city'

  class Entities.LocationCollection extends Entities.BaseCollection
    model: Entities.LocationModel
    url: -> Config.routePrefix + "locations"

  API = 
    getLocation: (data) ->
      model = new Entities.LocationModel data
      model

    getLocations: (data) ->
      collection = new Entities.LocationCollection data
      collection.fetch()

      collection

    getStaticLocations: (data) ->
      new Entities.LocationCollection data
      
  App.reqres.setHandler 'location:entities', API.getLocations
  App.reqres.setHandler 'location:entity', API.getLocation
  App.reqres.setHandler 'location:entities:airports', API.getStaticLocations
