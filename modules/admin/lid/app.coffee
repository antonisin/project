@Air.module 'Admin.Lids', (Lids, App, Backbone, Marionette, $, _) ->

  class Lids.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/lids': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'lids') unless region

      new Lids.ListController region: region

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'lids'

    App.navigate "admin/lids" 
    API.list region 

  App.addInitializer ->
    new Lids.Router
      controller: API
