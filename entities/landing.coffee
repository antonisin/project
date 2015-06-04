@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.LandingModel extends Entities.BaseModel
    urlRoot : Config.routePrefix + 'landing'
    defaults:
      id :      ''
      url:      ''
      location: ''
      landings: ''
      isPublic: 0

    validation:
      url:
        required: true

      location:
        required: true

      direction:
        required: true

      price:
        required: true
        pattern: 'number'

  class Entities.LandingDirectionModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'landing/direction/'
    defaults:
      name: ''
    validation:
      image:
        required: false
      name:
        required: true

  class Entities.LandingItemModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'landing/item/'
    defaults:
      id     : ''
      landing: ''
    validation:
      airline1:
        required: true

      airline2:
        required: true

      airline3:
        required: true

      airline4:
        required: true

      price1:
        required: true
        pattern: 'number'

      price2:
        required: true
        pattern: 'number'

      price3:
        required: true
        pattern: 'number'

      price4:
        required: true
        pattern: 'number'

      location:
        required: true

  class Entities.LandingItemCollection extends Entities.BaseCollection
    url: Config.routePrefix + 'landing/item/'
    model: Entities.LandingItemModel

  class Entities.LandingCollection extends Entities.BaseCollection
    model: Entities.LandingModel

  class Entities.LandingDirectionsCollection extends Entities.BaseCollection
    url: Config.routePrefix + 'landing/direction/'
    model: Entities.LandingDirectionModel

  API =
    getLandingItemCollection: (model) ->
      new Entities.LandingItemCollection model.get('landingItems')

    getLandingItemNew: (id) ->
      new Entities.LandingItemModel({landing: id})

    getLandingModel: ->
      new Entities.LandingModel

    getLandingCollection: ->
      collection     = new Entities.LandingCollection
      collection.url = Config.routePrefix + 'landing/all/'
      collection.fetch()
      collection

    getLandingDirections: ->
      new Entities.LandingDirectionsCollection window.data['landingdirections']

    getLandingDirectionsNew: ->
      new Entities.LandingDirectionModel


  App.reqres.setHandler 'landing:item:entitie', API.getLandingItemCollection
  App.reqres.setHandler 'landing:entitie', API.getLandingCollection
  App.reqres.setHandler 'landing:new:entity', API.getLandingModel

  App.reqres.setHandler 'landing:directions:entitie', API.getLandingDirections
  App.reqres.setHandler 'landing:direction:new:entity', API.getLandingDirectionsNew

  App.reqres.setHandler 'landing:item:new:entity', API.getLandingItemNew
