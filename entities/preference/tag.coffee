@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.TagModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'preference/tag'
    validation:
      name:
        required: true
      icon:
        required: true
    defaults:
      name: ''
      inList: 0
      showCounter: 1
      isSystem: 0

  class Entities.TagsCollection extends Entities.BaseCollection
    model: Entities.TagModel
    url  :-> Config.routePrefix + 'preference/tags'

  API =
    getCollection: ->
      collection = new Entities.TagsCollection
      collection.fetch()
      collection

    getNewModel: ->
      new Entities.TagModel

  App.reqres.setHandler 'preference:tags:collection', API.getCollection
  App.reqres.setHandler 'preference:tag:model:new', API.getNewModel
