@Air.module 'Admin.AirplaneType', (AirplaneType, App, Backbone, Marionette, $, _) ->

  class AirplaneType.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/airplaneTypes': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'airplaneTypes') unless region
      new AirplaneType.List.ListController region: region
      
    edit: (model) ->
      new AirplaneType.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new AirplaneType.Edit.EditController
        region: App.dialog
        model: App.request 'airplaneType:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'airplaneTypes'

    App.navigate "admin/airplaneTypes" 
    API.list region 

  App.addInitializer ->
    new AirplaneType.Router
      controller: API

  App.vent.on 'admin:airplaneType:edit', (model) ->
    API.edit model

  App.vent.on 'admin:airplaneType:add',->
    API.add()
