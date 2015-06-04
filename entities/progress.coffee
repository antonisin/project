@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.ProgressModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'progress'

    validation:
      name:
        required: true

      type:
        required: true

      rank:
        required: true

      range:
        required: true

      comment:
        required: true

      image:
        required: true

    defaults:
      type:  0
      range: ''
      image: ''

  class Entities.ProgressCollection extends Entities.BaseCollection
    url: -> Config.routePrefix + 'progress'
    model: Entities.ProgressModel

  API =
    getCollection: ->
      collection = new Entities.ProgressCollection
      collection.fetch()
      collection

    getModel: =>
      new Entities.ProgressModel

  App.reqres.setHandler 'admin:progress:collection', API.getCollection
  App.reqres.setHandler 'admin:progress:model', API.getModel
