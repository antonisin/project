@Air.module 'Admin.Subscriber', (Subscriber, App, Backbone, Marionette, $, _) ->
  class Subscriber.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/subscribers': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'subscribers') unless region
      new Subscriber.List.ListController region: region
      
    edit: (collection, model) ->
      new Subscriber.Edit.EditController
        region    : App.dialog
        model     : model
        collection: collection

    add: (collection) ->
      new Subscriber.Edit.EditController
        region    : App.dialog
        model     : App.request 'subscriber:new:entity'
        collection: collection

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'subscribers'

    App.navigate "admin/subscribers" 
    API.list region 

  App.addInitializer ->
    new Subscriber.Router
      controller: API

  App.vent.on 'admin:subscriber:edit', (view, collection) ->
    API.edit collection, view.model

  App.vent.on 'admin:subscriber:add', (collection) ->
    API.add collection
