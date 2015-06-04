@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ReasonModel extends Entities.BaseModel
    urlRoot: -> Config.routePrefix + 'fine/reason'

    validation:
      text:
        required: true

      point:
        required: true

  class Entities.ReasonCollection extends Entities.BaseCollection
    url  : -> Config.routePrefix + 'fine/reason'
    model: Entities.ReasonModel

  class Entities.StatusModel extends Entities.BaseModel
    urlRoot: -> Config.routePrefix + 'fine/status'

    validation:
      text:
        required: true

  class Entities.StatusCollection extends Entities.BaseCollection
    url  : -> Config.routePrefix + 'fine/status'
    model: Entities.StatusModel

  API =
    getReasonCollection: ->
      collection = new Entities.ReasonCollection
      collection.fetch()
      collection

    getReasonModel: ->
      new Entities.ReasonModel

    getStatusCollection: ->
      collection = new Entities.StatusCollection
      collection.fetch()
      collection

    getStatusModel: ->
      new Entities.StatusModel


  App.reqres.setHandler 'admin:fine:reason:entities', API.getReasonCollection
  App.reqres.setHandler 'admin:fine:reason:entity', API.getReasonModel

  App.reqres.setHandler 'admin:fine:status:entities', API.getStatusCollection
  App.reqres.setHandler 'admin:fine:status:entity', API.getStatusModel
