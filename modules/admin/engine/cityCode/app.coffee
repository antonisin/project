@Air.module 'Admin.CityCode', (CityCode, App, Backbone, Marionette, $, _) ->
  class CityCode.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/cityCode': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'cityCode') unless region
      new CityCode.List.ListController region: region

    edit: (model) ->
      new CityCode.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new CityCode.Edit.EditController
        region: App.dialog
        model: App.request 'admin:cityCode:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'cityCode'

    App.navigate "admin/cityCode" 
    API.list region 

  App.addInitializer ->
    new CityCode.Router
      controller: API

  App.vent.on 'admin:cityCode:add', ->
    API.add()

  App.vent.on 'admin:cityCode:edit', (model) ->
    API.edit model