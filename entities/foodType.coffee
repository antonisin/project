@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.FoodTypeModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'foodTypes'
    validation:
      name:
        required: true
        msg     : 'Please enter a valid food type name (not null)'
      code:
        required: true
        msg     : 'Please enter a valid food type code (not null)'
      systemName:
        required: true
        msg     : 'Please enter a valid food type system name (not null)' 

  class Entities.FoodTypeCollection extends Entities.BaseCollection
    model: Entities.FoodTypeModel
    url: -> Config.routePrefix + "foodTypes"

  API = 
    getFoodType: (data) ->
      new Entities.FoodTypeModel data

    getFoodTypes: (data) ->
      collection = new Entities.FoodTypeCollection data
      collection.fetch()

      collection

  App.reqres.setHandler 'foodType:entities', API.getFoodTypes
  App.reqres.setHandler 'foodType:entity', API.getFoodType
