@Air.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.WatcherModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'watcher'

    validation:
      start:
        required: true
      end:
        required: true

  API =
    getWatcher: ->
      new Entities.WatcherModel

  App.reqres.setHandler 'watcher:entity', API.getWatcher