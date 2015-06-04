@Air.module 'Admin.Client', (Client, App, Backbone, Marionette, $, _) ->

  class Client.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/clients': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'clients') unless region
      new Client.List.ListController region: region
      
    edit: (model) ->
      new Client.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new Client.Edit.EditController
        region: App.dialog
        model: App.request 'client:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'clients'

    App.navigate "admin/clients" 
    API.list region 

  App.addInitializer ->
    new Client.Router
      controller: API

  App.vent.on 'admin:client:edit', (model) ->
    API.edit model

  App.vent.on 'admin:client:add',->
    API.add()
