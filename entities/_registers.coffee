@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ConsolidatorModel extends Entities.BaseModel
  class Entities.ConsolidatorCollection extends Entities.BaseCollection
    model: Entities.ConsolidatorModel

  App.reqres.setHandler 'consolidator:entities', ->
    new Entities.ConsolidatorCollection window.data['consolidators']