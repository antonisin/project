@Air.module 'Admin.Reason', (Reason, App, Backbone, Marionette, $, _) ->
  class Reason.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/reasons': 'list'

  API =
    list: (region) ->
      return App.execute('admin:list', 'reasons') unless region
      new Reason.List.ListController region: region

    change: (model) ->
      if !model then model = App.request 'admin:fine:reason:entity'
      new Reason.Change.Controller
        region: App.dialog
        model: model

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'reasons'

    App.navigate "admin/reasons"
    API.list region

  App.addInitializer ->
    new Reason.Router
      controller: API

  App.vent.on 'admin:reason:edit', (model) ->
    API.change model

  App.vent.on 'admin:reason:add', ->
    API.change()

