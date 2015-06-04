@Air.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.NotificationModel extends Entities.BaseModel

  class Entities.NotificationCollection extends Entities.BaseCollection
    model: Entities.NotificationModel
    url: -> Config.routePrefix + 'notification'

  API =
    getNotifications: (userId) ->
      collection = new Entities.NotificationCollection
      collection.url = Config.routePrefix + 'notification/' + userId
      collection.fetch()
      collection

  App.reqres.setHandler 'notification:entities', API.getNotifications