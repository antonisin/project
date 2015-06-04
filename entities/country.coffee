@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.CountryModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'countries'
    defaults    :
      name: ''
      code: ''
      code2: ''
      code3: ''

    validation:
      code2: 
        required: true
        msg: "Please enter a valid code2"
      code3:
        required: true
        msg: "Please enter a valid code3"
      name_ru:
        required: true
        msg: "Please enter a valid name ru"
      name_en:
        required: true
        msg: "Please enter a valid name en"

  class Entities.CountryCollection extends Entities.BaseCollection
    model: Entities.CountryModel
    url: -> Config.routePrefix + "countries"

  API = 
    getCountry: (data) ->
      country = new Entities.CountryModel data
      country.fetch()

      country

    getCountries: (data) ->
      collection = new Entities.CountryCollection data
      collection.fetch()

      collection

  App.reqres.setHandler 'country:entities', API.getCountries
  App.reqres.setHandler 'country:entity', API.getCountry
