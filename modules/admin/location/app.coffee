@Air.module 'Admin.Location', (Location, App, Backbone, Marionette, $, _) ->

  class Location.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/locations': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'locations') unless region
      new Location.List.ListController region: region
      
    edit: (model) ->
      new Location.Edit.EditController
        region: App.dialog
        model : model

    add: ->
      new Location.Edit.EditController
        region: App.dialog
        model : App.request 'location:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'locations'

    App.navigate "admin/locations" 
    API.list region 

  App.addInitializer ->
    new Location.Router
      controller: API

  App.vent.on 'admin:location:edit', (id) ->
    API.edit id

  App.vent.on 'admin:location:add',->
    API.add()
