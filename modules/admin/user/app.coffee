@Air.module 'Admin.Users', (Users, App, Backbone, Marionette, $, _) ->

  class Users.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/users': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'users') unless region
      new Users.List.ListController region: region
      
    edit: (model) ->
      new Users.Edit.EditController
        region: App.dialog
        model: model
        collection: model.collection

    add: (collection) ->
      new Users.Edit.EditController
        region    : App.dialog
        collection: collection
        model     : App.request('user:entity')

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'users'

    App.navigate "admin/users" 
    API.list region 

  App.addInitializer ->
    new Users.Router
      controller: API

  App.vent.on 'admin:user:edit', (model) ->
    API.edit model

  App.vent.on 'admin:user:add', (collection) ->
    API.add collection
