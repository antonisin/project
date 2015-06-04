@Air.module 'Admin.Progress', (Progress, App, Backbone, Marionette, $, _) ->

  class Progress.Router extends App.Routers.BaseRouter
    menuItem: 'admin'
    role: ['admin']
    appRoutes:
      'admin/progress': 'list'

  API =
    list: (region) ->
      return App.execute('admin:list', 'progress') unless region
      new Progress.View.Controller region: region

    change: (model) ->
      if !model then model = App.request 'admin:progress:model'
      new Progress.Change.Controller
        model: model
        region: App.dialog

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'progress'

    App.navigate 'admin/progress'
    API.list region

  App.addInitializer ->
    new Progress.Router
      controller: API

  App.vent.on 'admin:progress:model:add', =>
    API.change()

  App.vent.on 'admin:progress:model:edit', (model) =>
    API.change model
