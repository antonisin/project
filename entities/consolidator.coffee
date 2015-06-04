@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ConsolidatorModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'consolidators'
    defaults    :
      name: ''
      systemName: ''
    validation:
      name:
        required: true
        msg     : 'please enter a valid name/ not null'
      systemName:
        required: true
        msg     : 'Please enter a valid sistem name/ not null'    

  class Entities.ConsolidatorCollection extends Entities.BaseCollection
    model: Entities.ConsolidatorModel
    url: -> Config.routePrefix + "consolidators"

  API = 
    getConsolidator: (data) ->
      new Entities.ConsolidatorModel data

    getConsolidators: (data) ->
      collection = new Entities.ConsolidatorCollection data
      collection.fetch()

      collection

  App.reqres.setHandler 'consolidator:entities', API.getConsolidators
  App.reqres.setHandler 'consolidator:entity', API.getConsolidator
