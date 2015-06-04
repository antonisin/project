@Air.module 'Admin.Settings', (Settings, App, Backbone, Marionette, $, _) ->

  class Settings.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/settings': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'settings') unless region
      new Settings.List.ListController region: region
      
    edit: (model) ->
      new Settings.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new Settings.Edit.EditController
        region: App.dialog
        model: App.request 'setting:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'settings'

    App.navigate "admin/settings" 
    API.list region 

  App.addInitializer ->
    new Settings.Router
      controller: API

  App.vent.on 'admin:setting:edit', (model) ->
    API.edit model

  App.vent.on 'admin:setting:add',->
    API.add()
