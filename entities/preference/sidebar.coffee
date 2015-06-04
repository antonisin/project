@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.PreferenceMenuModel extends Entities.BaseModel

  class Entities.PreferenceMenuCollection extends Entities.BaseCollection
    model: Entities.PreferenceMenuModel

  API =
    getCollection: ->
      new Entities.PreferenceMenuCollection [
        { name: 'Категории', menuItem: 'tags'}
#        { name: 'item2', menuItem: ''}
      ]
  App.reqres.setHandler 'preference:sidebar:collection', API.getCollection
