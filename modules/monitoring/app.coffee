@Air.module 'Monitoring', (Monitoring, App, Backbone, Marionette, $, _) ->

  class Monitoring.Router extends App.Routers.BaseRouter
    menuItem: 'monitoring'
    appRoutes:
      'monitoring'          : 'list'
      'monitoring/archive/:id' : 'archive'

  API =
    list: ->
      new Monitoring.List.Controller region: App.content

    archive: (id) ->
      new Monitoring.Archive.Controller
        region: App.content
        sipId : id

    comment: (model) ->
      new Monitoring.Comment.Controller
        region: App.dialog
        model : model

    tag: (model) ->
      new Monitoring.Tag.Controller
        region: App.dialog
        model : model

  App.addInitializer ->
    new Monitoring.Router
      controller: API

    App.vent.on 'monitoring:archive', (model) =>
      @navigate "monitoring/archive/#{model.id}"
      API.archive model.id

    App.vent.on 'monitoring:archive:comment', (model) =>
      API.comment model

    App.vent.on 'monitoring:archive:tag', (model) =>
      API.tag model
