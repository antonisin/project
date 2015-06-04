@Air.module 'Admin.Airline', (Airline, App, Backbone, Marionette, $, _) ->
  class Airline.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/airlines': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'airlines') unless region
      new Airline.List.ListController region: region
      
    edit: (model) ->
      new Airline.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new Airline.Edit.EditController
        region: App.dialog
        model: App.request 'airline:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'airlines'

    App.navigate "admin/airlines" 
    API.list region 

  App.addInitializer ->
    new Airline.Router
      controller: API

  App.vent.on 'admin:airline:edit', (model) ->
    API.edit model

  App.vent.on 'admin:airline:add',->
    API.add()
