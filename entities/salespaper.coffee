@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.SalePaperModel extends Entities.BaseModel
  class Entities.SalesPaperCollection extends Entities.BaseCollection
    model: Entities.SalePaperModel

  API =
    getCollection: (json) ->
      new Entities.SalesPaperCollection json

  App.reqres.setHandler 'lid:sale:paper:collection', API.getCollection

