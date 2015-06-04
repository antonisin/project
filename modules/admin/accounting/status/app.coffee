@Air.module 'Admin.Status', (Status, App, Backbone, Marionette, $, _) ->

  class Status.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/status': 'list'

  API =
    list: (region) ->
      return App.execute('admin:list', 'status') unless region
      new Status.List.ListController region: region

    change: (model) ->
      if !model then model = App.request 'admin:fine:status:entity'
      new Status.Change.Controller
        region: App.dialog
        model: model

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'status'

    App.navigate "admin/status"
    API.list region

  App.addInitializer ->
    new Status.Router
      controller: API

  App.vent.on 'admin:status:edit', (model) ->
    API.change model

  App.vent.on 'admin:status:add', ->
    API.change()
