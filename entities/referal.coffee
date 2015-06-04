@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ReferalModel extends Entities.BaseModel
    urlRoot: -> Config.routePrefix + 'search_engine'

    validation:
      name:
        required: true

      code:
        required: true
        pattern: 'number'

  class Entities.ReferalCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'search_engine'
    model: Entities.ReferalModel

  API = 
    getReferalCollection: ->
      collection = new Entities.ReferalCollection
      collection.fetch()
      collection

    getReferalModel: ->
      new Entities.ReferalModel

  App.reqres.setHandler 'admin:referal:entities', API.getReferalCollection
  App.reqres.setHandler 'admin:referal:entity', API.getReferalModel
