@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.PhoneModel extends Entities.BaseModel
    urlRoot: -> Config.routePrefix + 'phone'

    validation:
      number:
        required: true
        pattern: 'number'

      cityCode:
        required: true

      searchEngine:
        required: true

  class Entities.PhoneCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'phone'
    model: Entities.PhoneModel

  API = 
    getPhoneCollection: ->
      collection = new Entities.PhoneCollection
      collection.fetch()
      collection
    
    getPhoneModel:->
      new Entities.PhoneModel

  App.reqres.setHandler 'admin:phone:entities', API.getPhoneCollection
  App.reqres.setHandler 'admin:phone:entity', API.getPhoneModel
